require 'facets/file/atomic_open'
require 'facets/file/atomic_write'
require 'xezat/commands'
require 'xezat/variables'

module Xezat
  # 生成するファイルを上書き許可なしで上書きしようとした場合に投げられる例外
  class UnregeneratableConfigurationError < StandardError
  end

  # configure.(ac|in) が存在しない場合に投げられる例外
  class ConfigureNotFoundError < StandardError
  end

  module Command
    # 追加のファイルを生成する
    class Generate
      def initialize(program)
        program.command(:generate) do |c|
          c.syntax 'generate [options] cygport'
          c.description 'generate additional files'
          c.option 'overwrite', '-o', '--overwrite', 'overwrite file'
          c.option 'pc', '-p', '--pkg-config', 'generate *.pc'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager.register(:generate, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args}" unless args.empty?

        variables = VariableManager.get_default_variables(cygport)

        generate_pkg_config(variables, options) if options['pc']

        if variables[:_cmake_CYGCLASS_]
          result, detail = append_commands_to_cmakelists(variables)
        else
          result, detail = append_commands_to_configure(variables)
        end
        c.logger.info detail if result
      end

      # *.pc を生成する
      def generate_pkg_config(variables, options)
        srcdir = variables[:CYGCMAKE_SOURCE] || variables[:S]
        pc = File.expand_path(File.join(srcdir, "#{variables[:PN]}.pc.in"))
        raise UnregeneratableConfigurationError, "#{variables[:PN]}.pc.in already exists" if File.exist?(pc) && !options['overwrite']
        File.atomic_write(pc) do |f|
          f.write(get_package_config(variables))
        end
      end

      # CMakeLists.txt の末尾に *.pc を生成する命令を追記する
      def append_commands_to_cmakelists(variables)
        srcdir = variables[:CYGCMAKE_SOURCE] || variables[:S]
        cmakelists = File.expand_path(File.join(srcdir, 'CMakeLists.txt'))
        puts cmakelists
        original = File.read(cmakelists)
        commands = File.read(File.expand_path(File.join(TEMPLATE_DIR, 'pkgconfig.cmake')))

        unless original =~ /DESTINATION \$\{CMAKE_INSTALL_PREFIX\}\/lib\/pkgconfig/
          File.atomic_open(cmakelists, 'a') do |f|
            f.write(commands)
          end
          return [true, "append #{variables[:PN]}.pc installation commands to #{cmakelists}"]
        end
        [false, '']
      end

      # configure.ac と Makefile.am の末尾に *.pc を生成する命令を追加する
      def append_commands_to_configure(variables)
        result = false
        detail = []

        srcdir = variables[:CYGCONF_SOURCE] || variables[:S]
        configure_ac = File.expand_path(File.join(srcdir, 'configure.ac'))
        configure_ac = File.expand_path(File.join(srcdir, 'configure.in')) unless File.exist?(configure_ac)
        raise ConfigureNotFoundError unless File.exist?(configure_ac)
        original_ac = File.read(configure_ac)

        unless original_ac =~ /#{variables[:PN]}.pc/
          original_ac.gsub!(/(AC_CONFIG_FILES\(\[)/, '\1' + "#{variables[:PN]}.pc ")
          File.atomic_write(configure_ac) do |fa|
            fa.write(original_ac)
          end
          result = true
          detail << "append #{variables[:PN]}.pc installation commands to #{configure_ac}"
        end

        makefile_am = File.expand_path(File.join(srcdir, 'Makefile.am'))
        raise MakefileNotFoundError unless File.exist?(makefile_am)
        original_am = File.read(makefile_am)

        unless original_am =~ /pkgconfig_DATA/
          commands_am = File.read(File.expand_path(File.join(TEMPLATE_DIR, 'Makefile.am')))
          File.atomic_open(makefile_am, 'a') do |fm|
            fm.write(commands_am)
          end
          result = true
          detail << "append #{variables[:PN]}.pc installation commands to #{makefile_am}"
        end

        [result, detail.join(',')]
      end

      # シェル変数群を埋め込まれたテンプレート文字列を返す
      def get_package_config(variables)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'pkgconfig.erb'))
        ERB.new(File.readlines(erb).join(nil), nil, '%-').result(binding)
      end
    end
  end
end

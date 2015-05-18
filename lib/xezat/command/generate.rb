require 'facets/file/atomic_open'
require 'facets/file/atomic_write'
require 'xezat/commands'
require 'xezat/variables'

module Xezat
  # 生成するファイルを上書き許可なしで上書きしようとした場合に投げられる例外
  class UnregeneratableConfigurationError < StandardError
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

      CommandManager::register(:generate, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args.to_s}" unless args.empty?

        variables = VariableManager::get_default_variables(cygport)

        if options['pc']
          generate_pkg_config(variables, options)
        end

        if variables[:_cmake_CYGCLASS_]
          result, detail = append_commands_to_cmakelists(variables)
          c.logger.info detail if result
        end
      end

      # *.pc を生成する
      def generate_pkg_config(variables, options)
        pc = File::expand_path(File::join(variables[:S], "#{variables[:PN]}.pc.in"))
        raise UnregeneratableConfigurationError, "#{variables[:PN]}.pc.in already exists" if File::exist?(pc) && !options['overwrite']
        File::atomic_write(pc) do |f|
          f.write(get_package_config(variables))
        end
      end

      # CMakeLists.txt の末尾に *.pc を生成する命令を追記する
      def append_commands_to_cmakelists(variables)
        cmakelists = File::expand_path(File::join(variables[:S], "CMakeLists.txt"))
        original = File::read(cmakelists)
        commands = File::read(File::expand_path(File::join(TEMPLATE_DIR, 'pkgconfig.cmake')))

        unless original.match(/DESTINATION \$\{CMAKE_INSTALL_PREFIX\}\/lib\/pkgconfig/)
          File::atomic_open(cmakelists, 'a') do |f|
            f.write(commands)
          end
          return [true, "append #{variables[:PN]}.pc installation commands to #{cmakelists}"]
        end
        return [false, '']
      end

      # シェル変数群を埋め込まれたテンプレート文字列を返す
      def get_package_config(variables)
        erb = File::expand_path(File::join(TEMPLATE_DIR, 'pkgconfig.erb'))
        ERB.new(File::readlines(erb).join(nil), nil, '%-').result(binding)
      end
    end
  end
end

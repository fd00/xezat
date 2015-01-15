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
          c.option 'cmake', '-c', '--cmake', 'generate *.cmake'
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
          pc = File::expand_path(File::join(variables[:S], "#{variables[:PN]}.pc.in"))
          raise UnregeneratableConfigurationError, "#{variables[:PN]}.pc.in already exists" if File::exist?(pc) && !options['overwrite']
          File::atomic_write(pc) do |f|
            f.write(get_package_config(variables))
          end
        end
      end

      # シェル変数群を埋め込まれたテンプレート文字列を返す
      def get_package_config(variables)
        erb = File::expand_path(File::join(TEMPLATE_DIR, 'pkgconfig.erb'))
        ERB.new(File::readlines(erb).join(nil), nil, '%-').result(binding)
      end
    end
  end
end

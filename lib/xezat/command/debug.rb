require 'pp'
require 'xezat/commands'
require 'xezat/variables'

module Xezat
  module Command
    # 変数を表示する
    class Debug
      def initialize(program)
        program.command(:debug) do |c|
          c.syntax 'debug cygport'
          c.description 'show cygport variables'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager.register(:debug, self)

      def execute(c, args, _options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args}" unless args.empty?

        pp VariableManager.get_default_variables(cygport)
      end
    end
  end
end

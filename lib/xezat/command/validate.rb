require 'xezat/commands'
require 'xezat/validators'
require 'xezat/variables'

module Xezat
  module Command
    # package が妥当であるかを検証する
    class Validate
      def initialize(program)
        program.command(:validate) do |c|
          c.syntax 'validate [options] cygport'
          c.description 'validate package contents'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager::register(:validate, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args.to_s}" unless args.empty?
        variables = VariableManager::get_default_variables(cygport)
        ValidatorManager::load_default_validators
        ValidatorManager::validate(variables).each do |name, result|
          if result[:result].nil?
            c.logger.info "Validate #{name} ... skip"
          else
            if result[:result]
              c.logger.info "Validate #{name} ... OK"
            else
              c.logger.warn "Validate #{name} ... NG"
              c.logger.warn result[:detail]
            end
          end
        end

      end
    end
  end
end

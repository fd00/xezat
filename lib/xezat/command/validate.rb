
require 'xezat/xezat'
require 'xezat/commands'
require 'xezat/validators'

module Xezat

  # パッケージに含むファイル群が妥当かどうかを検証する
  class Validate < Command

    Commands.register(:validate, self)
    
    def initialize
      super(:validate, 'PKG-VER-REL.cygport')
      @message = 'Validate package'
    end
    
    def run(argv)
      
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end
      
      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい
      
      variables = VariableManager.get_default_variables(cygport)
      Validators.validate(variables)
      
    end
  end
end
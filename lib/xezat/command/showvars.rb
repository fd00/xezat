
require 'pp'

require 'xezat/xezat'
require 'xezat/commands'

module Xezat

  # デバッグ用にシェル変数を表示するコマンド
  class Showvars < Command
    
    Commands.register(:showvars, self)
    
    def initialize
      super(:showvars, 'PKG-VER-REL.cygport')
    end
    
    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      if argv.length == 0
        raise IllegalArgumentOfCommandException, 'cygport not specified'
      end
      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい
      
      variables = VariableManager.get_default_variables(cygport)
      pp variables
    end
    
  end
  
end

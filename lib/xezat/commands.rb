
require 'optparse'

require 'xezat/xezat'

module Xezat

  # コマンドの基底クラス
  class Command

    def initialize(command, extra = '')
      @help = false
      @op = OptionParser.new
      @op.banner = "Usage: xezat #{command} [option...] #{extra}"
      @op.on('-?', '--help', 'Show help message', TrueClass) { |v|
        @help = true
      }
    end

    def help
      @op.help
    end
    
    def comp(cygport)
      cygport + (cygport.end_with?('.cygport') ? '' : '.cygport')
    end
    
  end

  # コマンドのインスタンスを管理する
  class CommandManager

    def initialize
      @commands = {}
    end

    def register(command, klass)
      if @commands.has_key?(command)
        raise MultipleCommandDefinitionException, "'#{command}' already defined"
      end
      @commands[command] = klass
    end

    def instance(command)
      unless @commands.has_key?(command)
        raise NoSuchCommandDefinitionException, "#{command}: command not defined"
      end
      @commands[command].new
    end
    
    def load_commands(path)
      Dir.glob(File.join(path, '*.rb')) { |rb|
        require rb
      }
    end

  end

  unless defined?(Commands)
    Commands = CommandManager.new
    Commands.load_commands(File.join(File.dirname(__FILE__), 'command'))
  end
end


require 'optparse'

require 'xezat/xezat'

module Xezat

  # コマンドの基底クラス
  class Command

    def initialize(command, extra = '')
      @op = OptionParser.new
      @op.banner = "Usage: xezat #{command} [option...] #{extra}"
      @op.on('-?', '--help', 'Show help message', TrueClass) { |v|
        @help = true
      }
    end

    def help
      @op.help
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
      Dir.glob(path + '/*.rb') { |rb|
        require rb
      }
    end

  end

  Commands = CommandManager.new
  Commands.load_commands(File.dirname(__FILE__) + '/command')

end

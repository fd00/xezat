
require 'yacptool/yacptool'

module Yacptool

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
      if @commands[command] == nil
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
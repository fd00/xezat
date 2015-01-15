module Xezat
  # command が多重定義された場合に投げられる例外
  class MultipleCommandDefinitionError < StandardError
  end

  # command を管理するクラス
  class CommandManager
    @@commands = {}

    # command を登録する
    def self.register(name, klass)
      raise MultipleCommandDefinitionError, "'#{name}' already defined" if @@commands.key?(name)
      @@commands[name] = klass.new(@@program)
    end

    # command をロードする
    def self.load_default_commands(path = File::expand_path(File::join(File::dirname(__FILE__), 'command')))
      Dir::glob(File::join(path, '*.rb')) do |rb|
        require rb
      end
    end

    def self.program=(program)
      @@program = program
    end
    
    def self.[](name)
      @@commands[name]
    end

  end
end

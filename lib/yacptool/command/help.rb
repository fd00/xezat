
require 'yacptool/yacptool'
require 'yacptool/commands'

module Yacptool

  # ヘルプを表示させるコマンド
  class Help < Command

    Commands.register(:help, self)

    def initialize
      super
      @help = false
    end

    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end
      print
    end

    # すべてのコマンドのヘルプを集めて文字列として返す
    def aggregate(command_path = File.dirname(__FILE__))
      helps = []
      Dir.glob(command_path + '/*.rb') { |rb|
        command = Commands.instance(File.basename(rb, '.rb').intern)
        begin
          command.run(['-?'])
        rescue IllegalArgumentOfCommandException
          helps << command.help
        end
      }
      helps
    end

    def print
      aggregate.each { |line|
        puts line
      }
    end

  end

end
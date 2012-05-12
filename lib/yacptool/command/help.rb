
require 'optparse'
require 'yacptool/yacptool'
require 'yacptool/commands'

module Yacptool

  # ヘルプを表示させるコマンド
  class Help

    Commands.register(:help, self)

    def initialize
      @help = false

      @op = OptionParser.new
      @op.banner = 'Usage: yacptool help [option...]'
      @op.on('-?', '--help', 'Show help message', TrueClass) { |v|
        @help = true
      }
    end

    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end
      print
    end

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

    def help
      @op.help
    end

  end

end
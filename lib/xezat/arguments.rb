
require 'optparse'

require 'xezat/xezat'

module Xezat

  # コマンドライン引数を解析するクラス
  class Arguments

    attr_reader :command, :args

    def initialize
      @help = false
      @command = nil
      @args = nil

      @op = OptionParser.new
      @op.version = '0'
      @op.banner = 'Usage: xezat [options] <command> [command_option...]'
      @op.on('-?', '--help', 'Show help message', TrueClass) { |v|
        @help = true
      }
    end

    def parse(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfMainException, 'help specified'
      else
        if argv.length == 0
          raise IllegalArgumentOfMainException, 'command not specified'
        end
        @command = argv.shift.intern
        @args = argv
      end
    end

    def help
      @op.help
    end

  end

end

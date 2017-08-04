require 'thor'

module Xezat
  module Command
    class Debug < Thor

      desc 'linguist cygport', 'Show used programming languages'

      def linguist(cygport)
        require 'xezat/debugger/linguist'
        Debugger::Linguist.new(cygport).debug
      end

      desc 'variable cygport', 'Show variables'

      def variable(cygport)
        require 'xezat/debugger/variable'
        Debugger::Variable.new(cygport).debug
      end

    end
  end
end

# frozen_string_literal: true

require 'thor'

module Xezat
  module Command
    class Debug < Thor
      desc 'variable cygport', 'Show variables'

      def variable(cygport)
        require 'xezat/debugger/variable'
        Debugger::Variable.new(cygport).debug
      end
    end
  end
end

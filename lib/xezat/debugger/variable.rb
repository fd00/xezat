# frozen_string_literal: true

require 'pp'
require 'xezat/variables'

module Xezat
  module Debugger
    class Variable
      include Xezat

      def initialize(cygport)
        @cygport = cygport
      end

      def debug
        pp variables(@cygport)
      end
    end
  end
end

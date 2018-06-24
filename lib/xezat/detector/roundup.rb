# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Roundup
      def detect(variables)
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('roundup')
        end
        false
      end
    end
  end
end

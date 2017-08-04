require 'find'

module Xezat
  module Detector
    class Gnulib
      def detect(variables)
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('gnulib-tools')
        end
        false
      end
    end
  end
end

# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Make
      def detect(variables)
        return true if variables.key?(:_cmake_CYGCLASS_)
        Find.find(variables[:B]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'Makefile') || file.end_with?(File::SEPARATOR + 'makefile')
        end
        File.foreach(File.join(variables[:top], variables[:cygportfile])) do |line|
          return true if line.index('cygmake')
        end
        false
      end
    end
  end
end

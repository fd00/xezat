# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Automake
      def detect(variables)
        return false unless variables.keys.index do |key|
          %i[_cmake_CYGCLASS_ _meson_CYGCLASS_ _ninja_CYGCLASS_].include?(key)
        end.nil?

        cygautoreconf = false
        File.foreach(File.join(variables[:S], variables[:cygportfile])) do |line|
          if line.index('cygautoreconf')
            cygautoreconf = true
            return true
          end
        end

        unless cygautoreconf
          File.foreach(File.join(variables[:S], variables[:cygportfile])) do |line|
            return false if line.index('src_compile')
          end
        end

        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.am')
        end
        false
      end
    end
  end
end

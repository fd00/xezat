# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Automake
      def detect(variables)
        return false unless variables.keys.index do |key|
          %i[_cmake_CYGCLASS_ _meson_CYGCLASS_ _ninja_CYGCLASS_].include?(key)
        end.nil?

        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.am')
        end

        false
      end
    end
  end
end

# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Ninja
      def detect?(variables)
        return true if variables.key?(:_meson_CYGCLASS_)

        Find.find(variables[:B]) do |file|
          return true if file.end_with?("#{File::SEPARATOR}build.ninja")
        end
        false
      end
    end
  end
end

# frozen_string_literal: true

module Xezat
  module Detector
    class Waf
      def detect(variables)
        if variables.key?(:_waf_CYGCLASS_)
          Find.find(variables[:S]) do |file|
            return false if file.end_with?(File::SEPARATOR + 'waf')
          end
          return true
        end
        false
      end
    end
  end
end

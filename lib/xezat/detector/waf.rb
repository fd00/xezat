# frozen_string_literal: true

module Xezat
  module Detector
    class Waf
      def detect(variables)
        variables.key?(:_waf_CYGCLASS_)
      end
    end
  end
end

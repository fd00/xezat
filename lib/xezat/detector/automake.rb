# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Automake
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.am')
        end
        false
      end
    end
  end
end

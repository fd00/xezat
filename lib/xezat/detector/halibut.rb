# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Halibut
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?('.but')
        end
        false
      end
    end
  end
end

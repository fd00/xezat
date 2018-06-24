# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Libtool
      def detect(variables)
        Find.find(variables[:S]) do |file|
          return true if file.end_with?(File::SEPARATOR + 'ltmain.sh')
        end
        false
      end
    end
  end
end

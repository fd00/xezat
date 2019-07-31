# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python37
      def detect(variables)
        File.directory?(File.join(variables[:D], 'usr', 'lib', 'python3.7'))
      end
    end
  end
end

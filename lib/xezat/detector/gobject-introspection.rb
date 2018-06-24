# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class GObjectIntrospection
      def detect(variables)
        File.directory?(File.join(variables[:D], 'usr', 'lib', 'girepository-1.0'))
      end
    end
  end
end

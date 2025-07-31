# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Cmake
      def detect?(variables)
        variables.key?(:_cmake_CYGCLASS_)
      end
    end
  end
end

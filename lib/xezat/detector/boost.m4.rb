# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class BoostM4
      def detect(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?(File::SEPARATOR + 'configure.ac') || file.end_with?(File::SEPARATOR + 'configure.in')

          File.foreach(file) do |line|
            return true if line.lstrip.start_with?('BOOST_REQUIRE')
          end
        end
        false
      end
    end
  end
end

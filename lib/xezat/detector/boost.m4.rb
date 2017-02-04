require 'find'
require 'xezat/detectors'

module Xezat
  module Detector
    class BoostM4
      DetectorManager.register(:'boost.m4', self)

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

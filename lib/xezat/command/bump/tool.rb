require 'xezat/detectors'

module Xezat
  module Command
    class Bump
      def get_tools(variables)
        DetectorManager.new().detect(variables)
      end
    end
  end
end

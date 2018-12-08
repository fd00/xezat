# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python2
      def detect(variables)
        return true if File.directory?(File.join(variables[:D], 'usr', 'lib', 'python2.7'))

        Find.find(variables[:D]) do |file|
          next unless file.end_with?('.py')

          File.foreach(file) do |line|
            return true if line.strip == '#!/usr/bin/env python' || line.strip == '#!/usr/bin/env python2'

            break
          end
        end
        false
      end
    end
  end
end

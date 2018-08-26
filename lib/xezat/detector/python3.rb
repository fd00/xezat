# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python3
      def detect(variables)
        return true if File.directory?(File.join(variables[:D], 'usr', 'lib', 'python3.6'))
        Find.find(variables[:D]) do |file|
          next unless file.end_with?('.py')
          File.foreach(file) do |line|
            return true if line.strip == '#!/usr/bin/env python3'
            break
          end
        end
        false
      end
    end
  end
end

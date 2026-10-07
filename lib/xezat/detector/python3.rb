# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python3
      def detect?(variables)
        return true if Dir.glob(File.join(variables[:D], 'usr', 'lib', 'python3.*')).any? { |dir| File.directory?(dir) }

        Find.find(variables[:D]) do |file|
          next unless file.end_with?('.py')

          first_line = File.readlines(file).first
          return true if %r{^#!\s*/usr/bin/env\s*python(3(\.\d+)?)?\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python(3(\.\d+)?)?\s*$}.match?(first_line)
        end
        false
      end
    end
  end
end

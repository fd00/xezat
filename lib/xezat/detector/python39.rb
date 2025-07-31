# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python39
      def detect?(variables)
        return true if File.directory?(File.join(variables[:D], 'usr', 'lib', 'python3.9'))

        Find.find(variables[:D]) do |file|
          next unless file.end_with?('.py')

          first_line = File.readlines(file).first
          return true if %r{^#!\s*/usr/bin/env\s*python\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/env\s*python3\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/env\s*python3.9\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python3\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python3.9\s*$}.match?(first_line)
        end
        false
      end
    end
  end
end

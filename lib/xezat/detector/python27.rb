# frozen_string_literal: true

require 'find'

module Xezat
  module Detector
    class Python27
      def detect(variables)
        return true if File.directory?(File.join(variables[:D], 'usr', 'lib', 'python2.7'))

        Find.find(variables[:D]) do |file|
          next unless file.end_with?('.py')

          first_line = File.readlines(file).first.chomp
          return true if %r{^#!\s*/usr/bin/env\s*python2\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/env\s*python2.7\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python2\s*$}.match?(first_line)
          return true if %r{^#!\s*/usr/bin/python2.7\s*$}.match?(first_line)
        end
        false
      end
    end
  end
end

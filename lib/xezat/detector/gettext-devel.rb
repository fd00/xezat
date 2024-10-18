# frozen_string_literal: true

module Xezat
  module Detector
    class GettextDevel
      def detect(variables)
        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          File.foreach(file) do |line|
            return true if /AM_GNU_GETTEXT|AM_ICONV|AC_GGZ_INTL/.match?(line.scrub.lstrip)
          end
        end
        false
      end
    end
  end
end

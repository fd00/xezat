# frozen_string_literal: true

require 'xezat'

module Xezat
  class FilePermissionError < StandardError
  end

  module Command
    class Bump
      def get_changelog(variables, options, readme_file)
        LOG.debug('Append latest log to changelog')
        current_version = variables[:PVR].intern
        if FileTest.exist?(readme_file)
          raise FilePermissionError, "Cannot read #{readme_file}" unless FileTest.readable?(readme_file)
          raise FilePermissionError, "Cannot write #{readme_file}" unless FileTest.writable?(readme_file)
          changelog = Cygchangelog.new(File.read(readme_file))
          message = options['message'] || 'Version bump.'
          changelog[current_version] = message unless changelog.key?(current_version)
        else
          changelog = Cygchangelog.new
          changelog[current_version] = 'Initial release by fd0 <https://github.com/fd00/>'
        end
        changelog
      end
    end
  end
end

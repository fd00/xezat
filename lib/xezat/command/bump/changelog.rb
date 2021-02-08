# frozen_string_literal: true

require 'xezat'

module Xezat
  class FilePermissionError < StandardError
  end

  module Command
    class Bump
      def get_changelog(variables, options, readme_file)
        Xezat.logger.debug('  Try to append latest log to changelog...')
        current_version = variables[:PVR].intern
        if FileTest.exist?(readme_file)
          raise FilePermissionError, "Cannot read #{readme_file}" unless FileTest.readable?(readme_file)
          raise FilePermissionError, "Cannot write #{readme_file}" unless FileTest.writable?(readme_file)

          changelog = Cygchangelog.new(File.read(readme_file))
          message = options['message'] || 'Version bump.'
          if changelog.length > 1 || !changelog.key?(current_version)
            changelog[current_version] = message # overwrite unless initial package
            Xezat.logger.debug("    '#{message}' appended")
          else
            Xezat.logger.warn('    Initial release protected')
          end
        else
          changelog = Cygchangelog.new
          changelog[current_version] = 'Initial release by fd0 <https://github.com/fd00/>'
          Xezat.logger.debug('    Initial release by you')
        end
        changelog
      end
    end
  end
end

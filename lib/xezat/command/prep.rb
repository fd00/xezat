# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'xezat'
require 'xezat/variables'

module Xezat
  module Command
    class Prep
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        Xezat.logger.debug('Start prep')
        invoke_cygport_command('fetch')
        invoke_cygport_command('prep')
        copy_readme_if_exists
        Xezat.logger.debug('End prep')
      end

      private

      def invoke_cygport_command(command)
        Xezat.logger.debug("  Execute cygport #{command}")
        script = File.expand_path(File.join(DATA_DIR, 'cygport.sh'))
        result, error, status = Open3.capture3("bash #{script} #{@cygport} #{command}")
        Xezat.logger.warn("  Stderr = #{error}") unless error.empty?
        raise CygportProcessError, error unless status.success?

        result
      end

      def copy_readme_if_exists
        vars = variables(@cygport)
        cygport_dir = File.dirname(File.expand_path(@cygport))
        readme_source = File.expand_path('README', cygport_dir)
        readme_dest = File.expand_path('README', vars[:C])

        return unless File.exist?(readme_source)

        Xezat.logger.debug("  Copy README from #{readme_source} to #{readme_dest}")
        FileUtils.cp(readme_source, readme_dest)
      end
    end
  end
end

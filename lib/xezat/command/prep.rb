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
        output = +''
        Open3.popen2e("bash #{script} #{@cygport} #{command}") do |_stdin, stdout_err, wait_thr|
          stdout_err.each_line do |line|
            $stdout.print(line)
            $stdout.flush
            output << line
          end
          raise CygportProcessError, output unless wait_thr.value.success?
        end
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

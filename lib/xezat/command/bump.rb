# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'find'
require 'json'
require 'xezat'
require 'xezat/command/bump/changelog'
require 'xezat/command/bump/development_package'
require 'xezat/command/bump/file'
require 'xezat/command/bump/runtime_package'
require 'xezat/command/bump/src_uri'
require 'xezat/cygchangelog'
require 'xezat/cygclasses'
require 'xezat/packages'
require 'xezat/variables'

module Xezat
  module Command
    class Bump
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        Xezat.logger.debug('Start bumping')
        pkgs = packages
        vars = variables(@cygport)
        readme_file = File.expand_path(File.join(vars[:C], 'README'))

        info = {}
        info[:src_uri] = get_src_uri(vars)
        info[:runtimes] = get_runtime_packages(vars, pkgs, @cygport)
        info[:files] = get_files(vars)
        info[:developments] = get_development_packages(vars, pkgs, info[:runtimes], info[:files])
        info[:changelog] = get_changelog(vars, @options, readme_file)

        Xezat.logger.debug('  Write ChangeLog atomically')
        File.atomic_write(readme_file) do |f|
          f.write(get_embedded_contents(vars, info))
        end

        Xezat.logger.debug('End bumping')
      end

      def get_embedded_contents(variables, info)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'README.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding).chop # remove redundant new line
      end
    end
  end
end

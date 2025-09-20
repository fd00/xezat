# frozen_string_literal: true

require 'fileutils'
require 'xezat'
require 'xezat/config'
require 'xezat/variables'

module Xezat
  class NoDistDirectoryError < StandardError
  end

  module Command
    class Dist
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        Xezat.logger.debug('Start distributing')
        vars = variables(@cygport)

        noop = @options[:noop]
        verbose = @options[:noop] || @options[:verbose]

        arch = vars[:ARCH]
        release_dir = File.expand_path(File.join(get_dist_directory(@options), arch, 'release'))
        pkg_dir = File.expand_path(File.join(release_dir, vars[:PN]))
        dist_dir = File.expand_path(File.join(vars[:distdir], vars[:PN]))

        if Dir.exist?(pkg_dir)
          Xezat.logger.warn("  Package directory already exists : #{pkg_dir} (skip)")
        else
          Xezat.logger.debug("  Copy package to release directory : #{pkg_dir}")
          FileUtils.cp_r(dist_dir, release_dir, noop:, verbose:)
        end

        Xezat.logger.debug('End distributing')
      end

      def get_dist_directory(options)
        conf = config(options[:config])
        dist_dir = conf['xezat']['distdir'] || options[:distdir]
        raise NoDistDirectoryError if dist_dir.nil?

        Xezat.logger.debug("  Dist directory: #{dist_dir}")
        dist_dir
      end
    end
  end
end

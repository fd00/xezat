require 'xezat/config'
require 'xezat/variables'

module Xezat

  class NoPortDirectoryError < StandardError
  end

  module Command
    class Port
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        vars = variables(@cygport)
        d = File.expand_path(File.join(get_port_directory(@options), vars[:PN]))
        fuo = {
            noop: @options[:noop],
            verbose: @options[:noop] || @options[:verbose]
        }

        FileUtils.mkdir_p(d, fuo)
        FileUtils.cp(File.expand_path(File.join(vars[:top], @cygport)), d, fuo)
        FileUtils.cp(File.expand_path(File.join(vars[:C], 'README')), d, fuo)
        src_patch = File.expand_path(File.join(vars[:patchdir], "#{vars[:PF]}.src.patch"))
        FileUtils.cp(src_patch, d, fuo) unless FileTest.zero?(src_patch)
      end

      def get_port_directory(options)
        conf = config(@options[:config])
        port_dir = conf['xezat']['portdir'] || options[:portdir]
        raise NoPortDirectoryError if port_dir.nil?
        port_dir
      end
    end
  end
end

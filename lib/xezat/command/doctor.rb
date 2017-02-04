require 'xezat/commands'
require 'zlib'

module Xezat
  module Command
    # package tree が健全であるかどうかを診断する
    class Doctor
      def initialize(program)
        program.command(:doctor) do |c|
          c.syntax 'doctor'
          c.description 'diagnose installed packages'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager.register(:doctor, self)

      def execute(c, _args, _options)
        get_contents_uniqueness.each do |path, pkg|
          c.logger.warn "#{path} is in multiple packages: #{pkg}" if pkg.length > 1
        end
      end

      def get_contents_uniqueness(path = '/etc/setup')
        content2pkg = {}
        Dir.glob(File.join(path, '*.lst.gz')) do |lst|
          pkg = File.basename(lst, '.lst.gz').intern
          Zlib::GzipReader.open(lst) do |gz|
            gz.each_line do |line|
              line.strip!
              next if line.end_with?('/')
              path = line.intern
              content2pkg[path] = [] unless content2pkg.key?(path)
              content2pkg[path] << pkg
            end
          end
        end
        content2pkg
      end
    end
  end
end

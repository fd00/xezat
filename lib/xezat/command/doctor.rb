# frozen_string_literal: true

require 'zlib'

module Xezat
  module Command
    class Doctor
      include Xezat

      def initialize; end

      def execute
        get_contents_uniqueness.each do |path, pkg|
          puts "#{path} is not unique: #{pkg}" if pkg.length > 1
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

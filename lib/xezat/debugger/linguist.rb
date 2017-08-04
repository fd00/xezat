require 'find'
require 'pp'
require 'xezat/ext/linguist/file_blob'
require 'xezat/variables'

module Xezat
  module Debugger
    class Linguist
      include Xezat

      def initialize(cygport)
        @cygport = cygport
      end

      def debug
        vars = variables(@cygport)
        lang2files = {}
        top_src_dir = vars[:S]
        Find.find(top_src_dir) do |path|
          next if FileTest.directory?(path)
          language = Xezat::Linguist::FileBlob.new(path).language
          next if language.nil?
          name = language.name
          lang2files[name] = [] unless lang2files.key?(name)
          lang2files[name] << path.gsub("#{top_src_dir}/", '')
        end
        pp lang2files
      end
    end
  end
end

# frozen_string_literal: true

module Xezat
  class CygclassManager
    def initialize(cygclass_dir = '/usr/share/cygport/cygclass')
      raise ArgumentError, "#{cygclass_dir} not found" unless Dir.exist?(cygclass_dir)

      @cygclasses = []
      @vcs_cygclasses = []
      Dir.glob(File.join(cygclass_dir, '*.cygclass')) do |filename|
        cygclass = File.basename(filename, '.cygclass')
        @cygclasses << cygclass.intern
        File.foreach(filename) do |line|
          @vcs_cygclasses << cygclass.intern if line.strip == "readonly -f #{cygclass}_fetch"
        end
      end
    end

    def include?(cygclass)
      @cygclasses.include?(cygclass)
    end

    def vcs?(cygclass)
      @vcs_cygclasses.include?(cygclass)
    end

    def vcs
      @vcs_cygclasses
    end
  end
end

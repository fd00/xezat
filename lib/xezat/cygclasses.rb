require 'xezat'

module Xezat
  # cygclass を管理するクラス
  class CygclassManager
    def initialize(cygclass_dir = '/usr/share/cygport/cygclass')
      @cygclasses = []
      @vcs_cygclassess = []
      if Dir.exist?(cygclass_dir)
        Dir.glob(File.join(cygclass_dir, '*.cygclass')) do |filename|
          cygclass = File.basename(filename, '.cygclass')
          @cygclasses << cygclass.intern
          File.foreach(filename) do |line|
            @vcs_cygclassess << cygclass.intern if "readonly -f #{cygclass}_fetch" == line.strip
          end
        end
      end
    end

    def include?(cygclass)
      @cygclasses.include?(cygclass)
    end

    def vcs?(cygclass)
      @vcs_cygclassess.include?(cygclass)
    end

    def vcs
      @vcs_cygclassess
    end
  end
end


require 'xezat/xezat'

module Xezat

  class CygclassManager

    def initialize(command_path = '/usr/share/cygport/cygclass')
      @cygclasses = []
      @fetcher_cygclassess = []
      if Dir.exists?(command_path)
        Dir.glob(File.join(command_path, '*.cygclass')) { |filename|
          cygclass = File::basename(filename, '.cygclass')
          @cygclasses << cygclass.intern
          
          # ファイル取得プロトコルが http* 以外のクラス
          File::foreach(filename) { |line|
            if 'readonly -f ' + cygclass + '_fetch' == line.strip
              @fetcher_cygclassess << cygclass.intern
            end
          }
        }
      end
    end

    def exists?(cygclass)
      @cygclasses.include?(cygclass)
    end

    def fetcher?(cygclass)
      @fetcher_cygclassess.include?(cygclass)
    end

  end

end

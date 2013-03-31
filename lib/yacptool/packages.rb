
require 'yacptool/yacptool'

module Yacptool

  class PackageManager
    
    # install.db を解析して Hash にする
    def initialize(str)
      @packages = {}
      str.lines { |line|
        record = line.split(/\s+/)
        unless record.size == 3 # /^hoge hoge-ver-rel.tar.bz2 0$/
          next
        end
        @packages[record[0]] = record[1].gsub(/\.tar\.bz2$/, '')
      }
    end
    
    def [](key)
      @packages[key]
    end

    def self.get_default_packages(db_path = '/etc/setup/installed.db')
      self.new(IO.read(db_path))
    end
    
  end

end
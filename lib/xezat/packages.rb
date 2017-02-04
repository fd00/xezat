module Xezat
  class PackageManager
    # install.db を解析して Hash にする
    def initialize(str)
      @packages = {}
      str.lines do |line|
        record = line.split(/\s+/)
        next unless record.size == 3 # /^hoge hoge-ver-rel.tar.bz2 0$/
        @packages[record[0].intern] = record[1].gsub(/\.tar\.bz2$/, '')
      end
    end

    def [](key)
      @packages[key]
    end

    def self.get_installed_packages(db_path = '/etc/setup/installed.db')
      new(File.read(db_path))
    end
  end
end

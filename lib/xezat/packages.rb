module Xezat
  def packages(db_path = '/etc/setup/installed.db')
    raise ArgumentError, "#{db_path} not found" unless File.exist?(db_path)
    packages = {}
    File.read(db_path).lines do |line|
      record = line.split(/\s+/)
      next unless record.size == 3 # /^hoge hoge-ver-rel.tar.bz2 0$/
      packages[record[0].intern] = record[1].gsub(/\.tar\.bz2$/, '')
    end
    packages
  end
end

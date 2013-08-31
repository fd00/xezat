
require 'digest/md5'

module Xezat

  # パッケージファイルの情報を管理するクラス
  class Tarball
    
    attr_accessor :path, :size, :checksum
    
    def initialize(path)
      @path = path
      @size = FileTest.size(path)
      @checksum = Digest::MD5.file(path).hexdigest
    end
    
  end
  
end

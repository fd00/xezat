
module Xezat
  
  # CYGWIN-PATCHES/README を管理するクラス
  class Readme
    
    def initialize(str)
      # TODO もっと上手く書けるはず
      found = false
      version = nil
      @logs = {}
      if str.empty?
        return
      end
      str.each_line { |line|
        line.rstrip!
        if found
          if match_data = /^----- version (.+) -----$/.match(line)
            version = match_data[1].intern
            next
          end
          if match_data = /^(.+)$/.match(line)
            unless version
              raise ReadmeSyntaxException, "version missing"
            end
            # TODO 一行しかないことが前提になってる
            @logs[version] = match_data[1]
            next
          end
        end
        if /^Port Notes:$/ === line
          found = true
        end
      }
      unless found
        raise ReadmeSyntaxException, "label (Port Notes:) missing"
      end
    end
    
    def [](key)
      @logs[key]
    end

    def exists?(key)
      @logs.has_key?(key)
    end
     
    def []=(key, value)
      @logs[key] = value
    end
    
    def each(&block)
      @logs.sort {|a, b| -(a <=> b)}.each { |key, value|
        block.call(key, value)
      }
    end
    
  end
  
end

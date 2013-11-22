
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
      @logs.sort {|a, b|
        compare(a[0], b[0])
      }.each { |key, value|
        block.call(key, value)
      }
    end
    
    def compare(a, b) # TODO もっとすんなり書けるはず
      a_ver_rel = a.to_s.split('-')
      b_ver_rel = b.to_s.split('-')
      a_ver = a_ver_rel[0]
      b_ver = b_ver_rel[0]
      if (Gem::Version.correct?(a_ver) && Gem::Version.correct?(b_ver))
        order = -(Gem::Version.create(a_ver) <=> Gem::Version.create(b_ver))
        unless order == 0
          return order
        end
        return -(a_ver_rel[1] <=> b_ver_rel[1])
      end
      a_ver_tag = a_ver
      b_ver_tag = b_ver
      unless Gem::Version.correct?(a_ver_tag)
        a_ver_tag = a_ver_tag.split('+')
        a_ver = a_ver_tag[0]
      end
      unless Gem::Version.correct?(b_ver_tag)
        b_ver_tag = b_ver_tag.split('+')
        b_ver = b_ver_tag[0]
      end
      if (Gem::Version.correct?(a_ver) && Gem::Version.correct?(b_ver))
        order = -(Gem::Version.create(a_ver) <=> Gem::Version.create(b_ver))
        unless order == 0
          return order
        end
        order = -(a_ver_tag[1] <=> b_ver_tag[1])
        unless order == 0
          return order
        end
        return -(a_ver_rel[1] <=> b_ver_rel[1])
      end
      raise ArgumentError
    end
    
  end
  
end

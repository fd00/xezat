
require 'xezat/tarball'

module Xezat

  # setup.hint を管理するクラス
  class Hint
    
    attr_accessor :name, :sdesc, :ldesc, :category, :requires
    attr_accessor :external_source, :version, :install, :source
    
    def initialize(str)
      @name = ''
      @sdesc = ''
      @ldesc = ''
      @category = []
      @requires = []
      @external_source = ''
      @version = ''
      @install = nil
      @source = nil
      str.each_line { |line|
        case line
        when /^sdesc: "([^"]*)"$/
          @sdesc = $1
        when /^ldesc: "([^"]*)"$/
          @ldesc = $1
        when /^ldesc: "([^"]*)$/
          @ldesc = $1.strip
        when /^category: ([A-Za-z0-9 ]+)$/
          @category = $1.split(/ +/)
        when /^requires: ([A-Za-z0-9\.\+_ -]+)$/
          @requires = $1.split(/ +/)
        when /^external-source: ([A-Za-z0-9\.\+_ -]+)$/
          @external_source = $1
        else # 行頭にラベルがないものは ldesc の続きだと解釈する
          line.strip!
          if line.end_with?('"')
            line.chop!
          end
          @ldesc = @ldesc + $/ + line
        end
      }
    end
        
  end
  
  class HintManager
    
    def initialize(rootdir)
      @packages = {}
      Dir.chdir(rootdir) {
        Find.find('.') { |f|
          f.gsub!(/^\.\//, '')
          if File.basename(f) == 'setup.hint'
            current = File.dirname(f)
            package = Hint.new(File.read(f))
            name = File.basename(current)
            package.name = name
            Find.find(current) { |b|
              case File.basename(b)
              when /^#{package.name}-(.*)-src\.tar\.bz2$/
                package.source = Tarball.new(b)
              when /^#{package.name}-(.*)\.tar\.bz2$/
                package.version = $1
                package.install = Tarball.new(b)
              end
            }
            if package.external_source
              parent = File.dirname(current)
              Find.find(parent) { |b|
                case File.basename(b)
                when /^#{package.external_source}-(.*)-src\.tar\.bz2$/
                  package.source = Tarball.new(b)
                end
              }
            end
            @packages[name.intern] = package
          end
        }
      }
    end

    def [](key)
      @packages[key]
    end
    
    def exists?(key)
      @packages.has_key?(key)
    end
    
    def each(&block)
      @packages.sort_by { |key, value| key }.each { |key, value|
        block.call(key, value)
      }
    end

  end

end

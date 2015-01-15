require 'rubygems'

module Xezat
  # package の changelog を管理するクラス
  class Cygchangelog
    def initialize(str = '')
      @changelogs = str.empty? ? {} : nil
      version = nil
      str.each_line do |line|
        line.rstrip!
        if /^Port Notes:$/ === line
          @changelogs = {}
        else
          unless @changelogs.nil?
            if match_data = /^----- version (.+) -----$/.match(line)
              version = match_data[1].intern
            else
              if match_data = /^(.+)$/.match(line)
                raise ReadmeSyntaxException, "Version missing" if version.nil?
                if @changelogs.key?(version)
                  @changelogs[version] << $/ << match_data[1]
                else
                  @changelogs[version] = match_data[1]
                end
              end
            end
          end
        end
      end
    end

    def [](key)
      @changelogs[key]
    end

    def []=(key, value)
      @changelogs[key] = value
    end

    def key?(key)
      @changelogs.key?(key)
    end

    def each(&block)
      @changelogs.sort do |a, b|
        - (Gem::Version.new(a[0]) <=> Gem::Version.new(b[0]))
      end.each do |k, v|
        block.call(k, v)
      end
    end

  end
end

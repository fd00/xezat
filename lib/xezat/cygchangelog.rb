require 'xezat/cygversion'

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
                raise ReadmeSyntaxException, 'Version missing' if version.nil?
                if @changelogs.key?(version)
                  @changelogs[version] << $INPUT_RECORD_SEPARATOR << match_data[1]
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

    def each
      @changelogs.sort do |a, b|
        -(Cygversion.new(a[0].to_s) <=> Cygversion.new(b[0].to_s))
      end.each do |k, v|
        yield(k, v)
      end
    end
  end
end

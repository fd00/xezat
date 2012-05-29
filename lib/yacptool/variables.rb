
module Yacptool
  
  # cygport 変数を管理するクラス
  class VariableManager

    # declare で出力した変数一覧を解析して Hash にする
    def initialize(str)
      @variables = {}
      str.lines { |line|
        unless matches = /^(?<key>\w+)=(?<value>.*)$/.match(line)
          break
        end
        @variables[matches[:key].strip.intern] =
          matches[:value].strip.gsub(/^'/, '').gsub(/'$/, '').strip
      }
    end

    def [](key)
      @variables[key]
    end

    def exists?(key)
      @variables.has_key?(key)
    end

    def each(&block)
      @variables.each { |key, value|
        block.call(key, value)
      }
    end

  end

end
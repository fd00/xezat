
module Yacptool
  
  # cygport 変数を管理するクラス
  class VariableManager

    def initialize()
      @variables = {}
    end

    def parse(str)
      str.lines { |line|
        break unless matches = /^(?<key>\w+)=(?<value>.*)$/.match(line)
        value = matches[:value].strip
        if value[0] == "'" && value[-1] == "'"
          value = value[1..-2]  # strip single quoted value
        end
        @variables[matches[:key].strip.intern] = value.strip
      }
    end

    def [](key)
      @variables[key]
    end

  end

  Variables = VariableManager.new

end
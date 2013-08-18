
require 'open3'

module Xezat
  
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

    def self.get_default_variables(cygport)
      command = File.expand_path(File.join(DATA_DIR, 'show_cygport_variable.sh')) + ' ' + cygport
      result, error, status = Open3.capture3(command)
      unless status.success?
        raise CygportProcessException, error
      end
      # TODO error はどうする？
      self.new(result)
    end

  end

end

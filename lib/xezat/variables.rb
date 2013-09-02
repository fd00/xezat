
require 'open3'
require 'uri'

module Xezat
  
  # cygport 変数を管理するクラス
  class VariableManager

    # declare で出力した変数一覧を解析して Hash にする
    def initialize(str)
      @variables = {}
      str.each_line { |line|
        unless matches = /^(?<key>\w+)=(?<value>.*)$/.match(line)
          break
        end
        key = matches[:key].strip.intern
        value = matches[:value].strip.gsub(/^'/, '').gsub(/'$/, '').strip
        case value[0]
        when '(' # 配列の場合は ruby array に変換する
          values = []
          s = StringScanner.new(value)
          while true
            case
            when s.scan_until(/\[(\d+)\]="([A-Za-z0-9-]+)"/)
              values << s[2]
            else
              break
            end
          end
          value = values
        when '$' # 改行を含む文字列の場合は ruby array に変換する
          values = value.gsub(/^\$'/, '').gsub(/'$/, '').split(/\\n/).collect { |line|
            line.gsub(/\\t/, '').gsub(/\\'/, "'")
          }
          unless key == :DESCRIPTION
            values = values.delete_if { |x|
              x.empty?
            }
          end
          value = values
        end
        @variables[key] = value
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

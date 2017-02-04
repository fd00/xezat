require 'open3'
require 'uri'
require 'yaml'
require 'xezat'

module Xezat
  # cygport 外部プロセスが異常終了した場合に投げられる例外
  class CygportProcessError < StandardError
  end

  # cygport 変数を管理するクラス
  class VariableManager
    def initialize(str, description = nil)
      @variables = YAML.safe_load(str).each_value do |v|
        v.strip! if v.respond_to?(:strip)
      end
      @variables[:DESCRIPTION] = description unless description.nil?
    end

    def [](key)
      @variables[key]
    end

    def key?(key)
      @variables.key?(key)
    end

    def each
      @variables.each do |key, value|
        yield(key, value)
      end
    end

    # 指定された cygport に基づいたシェル変数群を取得する
    def self.get_default_variables(cygport)
      command = ['bash', File.expand_path(File.join(DATA_DIR, 'show_cygport_variable.sh')), cygport]
      result, error, status = Open3.capture3(command.join(' '))
      raise CygportProcessError, error unless status.success?
      result.gsub!(/^.*\*\*\*.*$/, '')

      # DESCRIPTION だけ改行を保持したまま取り込みたい
      command = ['bash', File.expand_path(File.join(DATA_DIR, 'show_cygport_description.sh')), cygport]
      description, error, status = Open3.capture3(command.join(' '))
      raise CygportProcessError, error unless status.success?
      description.gsub!(/^.*\*\*\*.*$/, '')

      new(result, description)
    end
  end
end

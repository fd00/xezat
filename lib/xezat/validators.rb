module Xezat
  # validator が多重定義された場合に投げられる例外
  class MultipleValidatorDefinitionError < StandardError
  end

  # validator を管理するクラス
  class ValidatorManager
    @@validators = {}

    # validator を登録する
    def self.register(name, klass)
      raise MultipleValidatorDefinitionError, "'#{name}' already defined" if @@validators.key?(name)
      @@validators[name] = klass.new
    end

    # validator をロードする
    def self.load_default_validators(path = File::expand_path(File::join(File::dirname(__FILE__), 'validator')))
      Dir::glob(File::join(path, '*.rb')) do |rb|
        require rb
      end
    end

    # 登録されている validator で install tree を検証する
    def self.validate(variables)
      results = {}
      @@validators.each do |name, validator|
        result, detail = validator.validate(variables)
        results[name] = {result: result, detail: detail}
      end
      results
    end

    def self.[](name)
      @@validators[name]
    end

  end
end

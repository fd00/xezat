
module Xezat
  
  # パッケージに含まれるファイル群が妥当かどうかを検証する基底クラス
  class Validator
    # インタフェースのみ
    def validate(variables)
    end
    
  end
  
  class ValidatorManager
     
     def initialize
       @validators = {}
     end
 
     def register(validator, klass)
       if @validators.has_key?(validator)
         raise MultipleValidatorDefinitionException, "'#{validator}' already defined"
       end
       @validators[validator] = klass.new
     end
 
     def validate(variables)
       @validators.each { |validator, instance|
         instance.validate(variables)
       }
     end
     
     def load_validators(path)
       Dir.glob(File.join(path, '*.rb')) { |rb|
         require rb
       }
     end
     
   end
   
   unless defined?(Validators)
     Validators = ValidatorManager.new
     Validators.load_validators(File.join(File.dirname(__FILE__), 'validator'))
   end
  
end

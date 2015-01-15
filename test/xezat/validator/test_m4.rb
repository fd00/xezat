require 'xezat/validator/m4'

module Xezat::Test::Validator
  class M4Test < Test::Unit::TestCase
    include Xezat::Validator
    include Xezat
    def setup
      @validator = ValidatorManager[:m4]
    end

    def test_skip
      variables = {D: Dir.tmpdir, T: Dir.tmpdir}
      result, detail = @validator.validate(variables)
      assert_nil(result)
    end

    def test_yes
      variables = {D: File::join(File.dirname(__FILE__), 'fixture', 'm4', 'yes'), T: Dir::tmpdir}
      result, detail = @validator.validate(variables)
      assert_true(result)
    end
  end
end

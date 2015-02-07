require 'xezat/validator/pkgconfig'

module Xezat::Test::Validator
  class PkgconfigTest < Test::Unit::TestCase
    include Xezat
    def setup
      @validator = ValidatorManager[:pkgconfig]
    end

    def test_skip
      variables = {D: Dir.tmpdir}
      assert_equal([nil, nil], @validator.validate(variables))
    end

    def test_no_at
      variables = {D: File::join(File.dirname(__FILE__), 'fixture', 'pkgconfig', 'no_at')}
      assert_equal([false, '/usr/lib/pkgconfig/xezat.pc: contains @'], @validator.validate(variables))
    end

    def test_no_link
      variables = {D: File::join(File.dirname(__FILE__), 'fixture', 'pkgconfig', 'no_link')}
      assert_equal([false, '/usr/lib/pkgconfig/xezat.pc: no library flags found'], @validator.validate(variables))
    end

    def test_yes
      variables = {D: File::join(File.dirname(__FILE__), 'fixture', 'pkgconfig', 'yes')}
      assert_equal([true, nil], @validator.validate(variables))
    end
  end
end

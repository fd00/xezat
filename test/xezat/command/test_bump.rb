require 'xezat/command/bump'

module Xezat::Test::Command
  class BumpTest < Test::Unit::TestCase
    include Xezat::Command
    include Xezat

    def setup
      @command = CommandManager[:bump]
      @cygclass_manager = CygclassManager.new(File.join(File.dirname(__FILE__), '..', '..', 'cygport', 'cygclass'))
    end

    def test_get_src_uri
      variables = {SRC_URI: 'src1 src2'}
      src_uri = @command.get_src_uri(variables, @cygclass_manager)
      assert_equal(['src1', 'src2'], src_uri)
    end

    def test_get_src_uri_git
      variables = {SRC_URI: 'src1 src2', GIT_URI: 'git1'}
      src_uri = @command.get_src_uri(variables, @cygclass_manager)
      assert_equal(['git1'], src_uri)
    end
  end
end

require 'xezat/command/create'

module Xezat::Test::Command
  class CreateTest < Test::Unit::TestCase
    include Xezat::Command
    include Xezat
    def setup
      @command = CommandManager[:create]
      @cygclass_manager = CygclassManager.new(File.join(File.dirname(__FILE__), '..', '..', 'cygport', 'cygclass'))
      @repository_variables = {
        :HOMEPAGE => 'homepage',
        :SRC_URI => 'src_uri'
      }
    end

    # repository のシェル変数群から template のシェル変数群に変換する
    def test_get_template_variables
      expected = @repository_variables
      template_variables = @command.get_template_variables(@repository_variables, @cygclass_manager, [])
      assert_equal(@repository_variables, template_variables)
    end

    # cygclass ありの template のシェル変数群に変換する
    def test_get_template_variables_inherit
      expected = {
        :HOMEPAGE => 'homepage',
        :GIT_URI => nil
      }
      template_variables = @command.get_template_variables(@repository_variables, @cygclass_manager, [:git])
      assert_equal(expected, template_variables)
    end

    # 存在しない cygclass が指定された場合は例外を投げる
    def test_get_template_variables_raise_no_such_cygclass_error
      assert_raise(NoSuchCygclassError) do
        @command.get_template_variables(@repository_variables, @cygclass_manager, [:nonexistent])
      end
    end

    # vcs が複数指定された場合は例外を投げる
    def test_get_template_variables_raise_cygclass_conflict_error
      assert_raise(CygclassConflictError) do
        @command.get_template_variables(@repository_variables, @cygclass_manager, [:git, :svn])
      end
    end
  end
end

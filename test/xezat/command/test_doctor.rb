require 'xezat/command/doctor'
require 'zlib'

module Xezat::Test::Command
  class DoctorTest < Test::Unit::TestCase
    include Xezat::Command
    include Xezat
    def setup
      @command = CommandManager[:doctor]
    end

    def test_get_contents_uniqueness
      assert_equal({:"usr/bin/aaa"=>[:a], :"usr/bin/bbb"=>[:b1, :b2], :"usr/bin/ccc"=>[:b2]}, @command.get_contents_uniqueness(File::join(File.dirname(__FILE__), 'fixture', 'doctor')))
    end
  end
end

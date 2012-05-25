
require 'yacptool/command/check'

class CheckTest < Test::Unit::TestCase

  include Yacptool

  def test_aggregate
    check = Check.new
    file2pkg = check.aggregate(File.expand_path(File.join(File.dirname(__FILE__), 'fixture', 'etc', 'setup')))
    etc_dir = file2pkg['etc/dir/'.intern]
    assert_nil(etc_dir)
    usr_bin_conflict = file2pkg['usr/bin/conflict'.intern]
    assert_equal([:a, :b], usr_bin_conflict)
    usr_share_a_uniq = file2pkg['usr/share/a/uniq'.intern]
    assert_equal([:a], usr_share_a_uniq)
    usr_share_b_uniq = file2pkg['usr/share/b/uniq'.intern]
    assert_equal([:b], usr_share_b_uniq)
  end

end

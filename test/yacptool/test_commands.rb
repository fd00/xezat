
require 'yacptool/commands'

class CommandManagerTest < Test::Unit::TestCase
  
  include Yacptool
  
  def test_multiple_command_definition_exception
    commands = CommandManager.new
    commands.register(:foo, self)
    assert_raise(MultipleCommandDefinitionException) {
      commands.register(:foo, self)
    }
  end
  
  def test_getting_defined_command
    commands = CommandManager.new
    commands.register(:foo, Object)
    assert_nothing_thrown() {
      commands.instance(:foo)
    }
  end

  def test_getting_undefined_command
    commands = CommandManager.new
    commands.register(:foo, Object)
    assert_raise(NoSuchCommandDefinitionException) {
      commands.instance(:bar)
    }
  end

end
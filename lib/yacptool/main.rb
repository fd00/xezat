
require 'yacptool/arguments'
require 'yacptool/commands'

include Yacptool

args = Arguments.new

begin
  args.parse(ARGV)
rescue IllegalArgumentOfMainException
  puts args.help
  exit
end

begin
  command = Commands.instance(args.command)
  command.run(args.args)
rescue IllegalArgumentOfCommandException
  puts command.help
  exit
end


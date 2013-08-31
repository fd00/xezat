
require 'xezat/arguments'
require 'xezat/commands'

include Xezat

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
rescue IllegalArgumentOfCommandException => e
  puts e
  puts command.help
  exit
end

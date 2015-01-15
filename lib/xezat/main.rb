require 'logger/colors'
require 'mercenary'
require 'xezat/commands'
require 'xezat/version'

Mercenary.program(:xezat) do |p|
  p.version Xezat::VERSION
  p.description 'Xezat is the complement of cygport'
  p.syntax 'xezat <subcommand> [options]'

  Xezat::CommandManager::program = p
  Xezat::CommandManager::load_default_commands
end

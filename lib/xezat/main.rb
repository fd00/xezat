# frozen_string_literal: true

require 'thor'
require 'thor/zsh_completion'
require 'xezat'
require 'xezat/version'

module Xezat
  class Main < Thor
    include ZshCompletion::Command

    class_option :config, type: :string, aliases: '-c', desc: 'specify config', default: CONFIG_FILE
    class_option :help, type: :boolean, aliases: '-h', desc: 'help message'

    desc 'version', 'Print version'

    def version
      puts "Xezat #{Xezat::VERSION}"
    end

    desc 'init cygport', 'Create new cygport'
    option :category, type: :string, desc: 'specify category'
    option :description, type: :string, desc: 'specify description'
    option :inherit, type: :string, aliases: '-i', desc: 'specify cygclasses (comma-separated)'
    option :overwrite, type: :boolean, aliases: '-o', desc: 'overwrite CYGPORT'
    option :repository, type: :string, aliases: '-r', desc: 'specify repository'

    def init(cygport)
      require 'xezat/command/init'
      Command::Init.new(options, cygport).execute
    end

    desc 'bump cygport', 'Bump version (rewrite README)'
    option :message, type: :string, aliases: '-m', desc: 'specify message'

    def bump(cygport)
      require 'xezat/command/bump'
      Command::Bump.new(options, cygport).execute
    end

    desc 'debug subcommand', 'Debug cygport'
    require 'xezat/command/debug'
    subcommand 'debug', Command::Debug

    desc 'doctor', 'Check your system for potential problems'

    def doctor
      require 'xezat/command/doctor'
      Command::Doctor.new.execute
    end

    desc 'generate subcommand', 'Generate development file'
    require 'xezat/command/generate'
    subcommand 'generate', Command::Generate

    desc 'port cygport', 'Copy cygport to git repository'
    option :noop, type: :boolean, aliases: '-n', desc: 'dry run'
    option :portdir, type: :string, aliases: '-p', desc: 'specify port directory'

    def port(cygport)
      require 'xezat/command/port'
      Command::Port.new(options, cygport).execute
    end

    desc 'dist cygport', 'Copy dist directory to release directory'
    option :noop, type: :boolean, aliases: '-n', desc: 'dry run'
    option :distdir, type: :string, aliases: '-d', desc: 'specify dist directory'

    def dist(cygport)
      require 'xezat/command/dist'
      Command::Dist.new(options, cygport).execute
    end

    desc 'validate cygport', 'Validate files'
    option :ignore, type: :boolean, aliases: '-i', desc: 'ignore error'

    def validate(cygport)
      require 'xezat/command/validate'
      Command::Validate.new(options, cygport).execute
    end

    desc 'announce cygport', 'Show announce'

    def announce(cygport)
      require 'xezat/command/announce'
      Command::Announce.new(nil, cygport).execute
    end
  end
end

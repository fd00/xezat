#!/usr/bin/env ruby
here = File::dirname(__FILE__)
$:.unshift File::expand_path(File::join(here, '..', 'lib'))
$:.unshift File::expand_path(File::join(here))

Encoding::default_external = 'UTF-8'

require 'mercenary'
require 'test/unit'
require 'xezat'
require 'xezat/commands'
require 'xezat/detectors'

Xezat::CommandManager::program = Mercenary::Program.new(:xezat)
Xezat::DetectorManager::load_default_detectors

Test::Unit::AutoRunner.run(true, File::join(here, 'xezat'))

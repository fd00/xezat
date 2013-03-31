#!/usr/bin/env ruby
here = File.dirname(__FILE__)
$LOAD_PATH << File.expand_path(File.join(here, '..', 'lib'))
$LOAD_PATH << File.expand_path(File.join(here))

require 'test/unit'
Test::Unit::AutoRunner.run(true, './yacptool')

#!/usr/bin/env ruby
here = File.dirname(__FILE__)
$LOAD_PATH << File.expand_path(File.join(here, '..', 'lib'))
$LOAD_PATH << File.expand_path(File.join(here))

require 'test/unit'

require 'yacptool/test_commands'
require 'yacptool/test_cygclasses'
require 'yacptool/test_variables'

require 'yacptool/command/test_check'
require 'yacptool/command/test_create'
require 'yacptool/command/test_patches'

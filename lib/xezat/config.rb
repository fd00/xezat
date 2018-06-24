# frozen_string_literal: true

require 'inifile'

module Xezat
  def config(filepath = nil)
    config = IniFile.new
    config['cygwin'] = {
      'cygclassdir' => '/usr/share/cygport/cygclass'
    }
    config['xezat'] = {
    }
    config.merge!(IniFile.load(filepath)) if filepath
    config
  end
end

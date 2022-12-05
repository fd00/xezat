# frozen_string_literal: true

require 'yaml'

module Xezat
  def config(filepath = nil)
    config = {}
    config['cygwin'] = {
      'cygclassdir' => '/usr/share/cygport/cygclass'
    }
    config['xezat'] = {}
    config.merge!(YAML.load_file(filepath)) if filepath
    config
  end
end

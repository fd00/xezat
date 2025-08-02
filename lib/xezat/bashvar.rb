# frozen_string_literal: true

require 'bashvar'
require 'open3'
require 'xezat'

module Xezat
  def bashvar(cygport)
    command = ['bash', File.expand_path(File.join(DATA_DIR, 'bashvar.sh')), cygport]
    result, error, status = Open3.capture3(command.join(' '))
    raise CygportProcessError, error unless status.success?

    BashVar.parse(result, symbolize_names: true)
  end
end

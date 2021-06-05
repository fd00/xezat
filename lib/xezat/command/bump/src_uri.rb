# frozen_string_literal: true

require 'xezat'
require 'xezat/cygclasses'

module Xezat
  module Command
    class Bump
      def get_src_uri(variables, cygclasses = CygclassManager.new)
        Xezat.logger.debug('  Collect SRC_URI')
        cygclasses.vcs.each do |vcs|
          next unless variables.key?("_#{vcs}_CYGCLASS_".intern)

          src_uri_key = "#{vcs.to_s.upcase}_URI".intern
          return variables[src_uri_key].split if variables.key?(src_uri_key)
        end
        variables[:SRC_URI].split
      end
    end
  end
end

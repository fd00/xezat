# frozen_string_literal: true

require 'xezat'
require 'xezat/cygclasses'

module Xezat
  module Command
    class Bump
      def get_src_uri(vars, cygclasses = CygclassManager.new)
        LOG.debug('Collect SRC_URI')
        cygclasses.vcs.each do |vcs|
          next unless vars.key?("_#{vcs}_CYGCLASS_".intern)

          src_uri_key = "#{vcs.to_s.upcase}_URI".intern
          return vars[src_uri_key].split if vars.key?(src_uri_key)
        end
        vars[:SRC_URI].split
      end
    end
  end
end

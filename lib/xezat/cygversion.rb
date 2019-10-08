# frozen_string_literal: true

require 'rubygems'

module Xezat
  class Cygversion
    def initialize(str)
      matched = str.match(/(.+)-(.+)/)
      version = matched[1]
      @release = matched[2]
      split = version.split('+')
      @version = split[0].tr('_', '.')
      @revision = split.length >= 2 ? split[1].match(/(\d+)/)[0].to_i : Time.at(0).strftime('%Y%m%d').to_i
    end

    def to_v
      [Gem::Version.new(@version), @revision, @release]
    end

    def to_a
      [@version, @revision, @release]
    end

    def <=>(other)
      to_v <=> other.to_v
    end
  end
end

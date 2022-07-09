# frozen_string_literal: true

require 'rubygems'

module Xezat
  class Cygversion
    attr_reader :version

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
    rescue ArgumentError
      to_a
    end

    def to_a
      [@version, @revision, @release]
    end

    def <=>(other)
      result = (to_v <=> other.to_v)
      return result unless result.nil?

      (to_a <=> other.to_a)
    end
  end
end

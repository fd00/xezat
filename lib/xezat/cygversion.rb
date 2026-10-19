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
      [Gem::Version.new(@version), @revision, release_key]
    rescue ArgumentError
      [@version, @revision, release_key]
    end

    def to_a
      [@version, @revision, @release]
    end

    def <=>(other)
      result = (to_v <=> other.to_v)
      return result unless result.nil?

      (to_a <=> other.to_a)
    end

    private

    # Compare releases naturally so that 1bl10 comes after 1bl9
    def release_key
      @release.scan(/\d+|\D+/).map { |token| token.match?(/\A\d+\z/) ? [0, token.to_i] : [1, token] }
    end
  end
end

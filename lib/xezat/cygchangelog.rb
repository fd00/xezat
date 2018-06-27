# frozen_string_literal: true

require 'xezat/cygversion'

module Xezat
  class ReadmeSyntaxError < StandardError
  end

  class Cygchangelog
    def initialize(str = '')
      @changelogs = nil
      version = nil
      str.each_line do |line|
        line.rstrip!
        if line == 'Port Notes:'
          @changelogs = {}
          next
        end
        next if @changelogs.nil?
        match_version = /^----- version (.+) -----$/.match(line)
        if match_version
          version = match_version[1].intern
          next
        end
        match_content = /^(.+)$/.match(line)
        next unless match_content
        raise ReadmeSyntaxError, 'Version missing' if version.nil?
        if @changelogs.key?(version)
          @changelogs[version] << $INPUT_RECORD_SEPARATOR << match_content[1]
        else
          @changelogs[version] = match_content[1]
        end
      end
      @changelogs ||= {}
    end

    def [](key)
      @changelogs[key]
    end

    def []=(key, value)
      @changelogs[key] = value
    end

    def key?(key)
      @changelogs.key?(key)
    end

    def each
      logs = @changelogs.sort do |a, b|
        -(Cygversion.new(a[0].to_s) <=> Cygversion.new(b[0].to_s))
      end
      logs.each do |k, v|
        yield(k, v)
      end
    end
  end
end

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

        matched_version = /^----- version (.+) -----$/.match(line)
        if matched_version
          version = matched_version[1].intern
          next
        end
        matched_content = /^(.+)$/.match(line)
        next unless matched_content
        raise ReadmeSyntaxError, 'Version missing' if version.nil?

        if @changelogs.key?(version)
          @changelogs[version] << $INPUT_RECORD_SEPARATOR << matched_content[1]
        else
          @changelogs[version] = matched_content[1]
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

    def each(&block)
      logs = @changelogs.sort do |a, b|
        -(Cygversion.new(a[0].to_s) <=> Cygversion.new(b[0].to_s))
      end
      logs.each(&block)
    end

    def length
      @changelogs.length
    end
  end
end

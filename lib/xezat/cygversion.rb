require 'rubygems'

module Xezat
  # package の version を管理するクラス
  class Cygversion
    def initialize(str)
      matched = str.match(/(.+)-(.+)/)
      version = matched[1]
      @release = matched[2]
      splitted = version.split('+')
      @version = splitted[0]
      @revision = splitted.length >= 2 ? splitted[1].match(/(\d+)/)[0].to_i : Time::at(0).strftime('%Y%m%d').to_i
    end

    def to_a
      [@version, @revision, @release]
    end

    def <=>(operand)
      to_a <=> operand.to_a
    end
  end
end

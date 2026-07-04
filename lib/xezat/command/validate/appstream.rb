# frozen_string_literal: true

require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_appstream_path(variables)
        legacy_dir = File.join(variables[:D], '/usr/share/appdata')
        Dir.glob('*', base: legacy_dir).each do |file|
          Xezat.logger.error("    #{file} is in the legacy AppStream path /usr/share/appdata, move it to /usr/share/metainfo")
        end
      end
    end
  end
end

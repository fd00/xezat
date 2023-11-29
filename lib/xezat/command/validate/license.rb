# frozen_string_literal: true

require 'spdx'
require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_license(vars)
        license = vars[:LICENSE]
        if license.nil? || license.empty?
          Xezat.logger.warn('     LICENSE is not defined')
        elsif Spdx.valid?(license)
          Xezat.logger.debug("    LICENSE = #{license}")
        else
          Xezat.logger.error("    LICENSE = #{license} (invalid)")
        end

        license_uri = vars[:LICENSE_URI]
        if license_uri.nil? || license_uri.empty?
          Xezat.logger.warn('     LICENSE_URI is not defined')
        elsif license_uri.start_with?('https://', 'http://')
          Xezat.logger.debug("    LICENSE_URI = #{license_uri}")
          livecheck(license_uri)
        elsif File.exist?(File.join(vars[:S], license_uri))
          Xezat.logger.debug("    LICENSE_URI = #{license_uri}")
        else
          Xezat.logger.error("    LICENSE_URI = #{license_uri} (not found)")
        end
      end
    end
  end
end

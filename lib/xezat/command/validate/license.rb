# frozen_string_literal: true

require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_license(vars)
        licenses_file = File.expand_path(File.join(DATA_DIR, 'licenses.yaml'))
        licenses = YAML.safe_load(File.open(licenses_file), [Symbol])
        license = vars[:LICENSE]
        if license.nil? || license.empty?
          Xezat.logger.warn('     LICENSE is not defined')
        elsif licenses.include?(license)
          Xezat.logger.debug("    LICENSE is listed : #{license}")
        else
          Xezat.logger.error("    LICENSE is unlisted : #{license}")
        end

        license_uri = vars[:LICENSE_URI]
        if license_uri.nil?
          Xezat.logger.warn('     LICENSE_URI is not defined')
        elsif File.exist?(File.join(vars[:S], license_uri))
          Xezat.logger.debug("    LICENSE_URI exists : #{license_uri}")
        else
          Xezat.logger.error("    LICENSE_URI does not exist : #{license_uri}")
        end
      end
    end
  end
end

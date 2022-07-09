# frozen_string_literal: true

require 'pkg-config'
require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_config(variables, gcc_version)
        configs = Dir.glob(File.join(variables[:D], '/usr/bin/*-config'))
        configs.each do |config|
          basename = File.basename(config)
          Xezat.logger.debug("    #{basename} found")

          result, _, status = Open3.capture3("#{config} --cflags")
          if status.success?
            Xezat.logger.debug("      cflags = #{result.strip}")
          else
            Xezat.logger.warn('       cflags not supported')
          end

          result, _, status = Open3.capture3("#{config} --cxxflags")
          if status.success?
            Xezat.logger.debug("      cxxflags = #{result.strip}")
          else
            Xezat.logger.warn('       cxxflags not supported')
          end

          result, _, status = Open3.capture3("#{config} --libs")
          if status.success?
            Xezat.logger.debug("      libs = #{result.strip}")
            validate_libs(variables, result.strip, gcc_version)
          else
            Xezat.logger.warn('       libs not supported')
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'pkg-config'
require 'xezat'

module Xezat
  module Command
    class Validate
      def validate_config(variables, gcc_version)
        Dir.glob(File.join(variables[:D], '/usr/bin/*-config')).each do |config|
          Xezat.logger.debug("    #{File.basename(config)} found")

          begin
            result, _, status = Open3.capture3("#{config} --version")
            if status.success?
              modversion = result.strip
              Xezat.logger.debug("      modversion = #{modversion}")
              pv = variables[:PV][0].gsub(/\+.+$/, '')
              Xezat.logger.error("        modversion differs from $PN = #{pv}") unless modversion == pv
            else
              Xezat.logger.warn('       modversion not supported')
            end
          rescue StandardError => e
            Xezat.logger.warn("       #{config} not executable: #{e}")
            next
          end

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

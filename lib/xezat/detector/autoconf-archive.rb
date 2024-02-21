# frozen_string_literal: true

module Xezat
  module Detector
    class AutoconfArchive
      def detect(variables)
        return false unless variables.keys.index do |key|
          %i[_cmake_CYGCLASS_ _meson_CYGCLASS_ _ninja_CYGCLASS_].include?(key)
        end.nil?

        autoconf_archive_file = File.expand_path(File.join(DATA_DIR, 'autoconf-archive.yml'))
        autoconf_archive_macros = YAML.safe_load(File.open(autoconf_archive_file), symbolize_names: true, permitted_classes: [Symbol])

        Find.find(variables[:S]) do |file|
          next unless file.end_with?("#{File::SEPARATOR}configure.ac", "#{File::SEPARATOR}configure.in")

          autoconf_archive_macros.each do |macro|
            File.foreach(file) do |line|
              return true if line.strip.start_with?(macro)
            end
          end
        end
        false
      end
    end
  end
end

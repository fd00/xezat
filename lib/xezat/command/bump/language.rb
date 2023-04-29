# frozen_string_literal: true

require 'xezat'
require 'xezat/ext/linguist/file_blob'

module Xezat
  module Command
    class Bump
      def get_languages(top_src_dir)
        Xezat.logger.debug('  Collect languages')
        languages_file = File.expand_path(File.join(DATA_DIR, 'languages.yaml'))
        languages_candidates = YAML.safe_load(File.open(languages_file), symbolize_names: true, permitted_classes: [Symbol])
        languages = []
        Find.find(top_src_dir) do |path|
          next if FileTest.directory?(path)

          extname = File.extname(path)
          next if extname == '.inc' # ambiguous

          name = languages_candidates[extname.to_sym]
          if name.nil?

            language = Xezat::Linguist::FileBlob.new(path).language
            next if language.nil?

            name = language.name
          end
          languages << name.to_sym
        end
        languages.uniq
      end
    end
  end
end

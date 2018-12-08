# frozen_string_literal: true

require 'xezat'
require 'xezat/ext/linguist/file_blob'

module Xezat
  module Command
    class Bump
      def get_languages(top_src_dir)
        LOG.debug('Collect languages')
        languages_file = File.expand_path(File.join(DATA_DIR, 'languages.json'))
        languages_candidates = JSON.parse(File.read(languages_file))
        languages = []
        Find.find(top_src_dir) do |path|
          next if FileTest.directory?(path)

          name = languages_candidates[File.extname(path)]
          if name.nil?
            language = Xezat::Linguist::FileBlob.new(path).language
            next if language.nil?

            name = language.name
          end
          languages << name
        end
        languages.uniq
      end
    end
  end
end

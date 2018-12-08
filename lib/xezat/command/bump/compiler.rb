# frozen_string_literal: true

require 'xezat'

module Xezat
  module Command
    class Bump
      def get_compilers(languages, _variables)
        LOG.debug('Collect compilers')
        compiler_file = File.expand_path(File.join(DATA_DIR, 'compilers.json'))
        compiler_candidates = JSON.parse(File.read(compiler_file))
        compilers = []
        languages.uniq.each do |language|
          next unless compiler_candidates.key?(language)

          compiler_candidate = compiler_candidates[language]
          compilers << compiler_candidate['package'].intern
          next unless compiler_candidate.key?('dependencies')

          compiler_candidate['dependencies'].each do |dependency|
            compilers << dependency.intern
          end
        end
        compilers.uniq
      end
    end
  end
end

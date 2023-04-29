# frozen_string_literal: true

require 'xezat'

module Xezat
  module Command
    class Bump
      def get_compilers(languages, _variables)
        Xezat.logger.debug('  Collect compilers')
        compiler_file = File.expand_path(File.join(DATA_DIR, 'compilers.yaml'))
        compiler_candidates = YAML.safe_load(File.open(compiler_file), symbolize_names: true, permitted_classes: [Symbol])
        compilers = []
        languages.uniq.each do |language|
          next unless compiler_candidates.key?(language)

          compiler_candidate = compiler_candidates[language]
          compilers << compiler_candidate[:package].intern
          next unless compiler_candidate.key?(:dependencies)

          compiler_candidate[:dependencies].each do |dependency|
            compilers << dependency.intern
          end
        end
        compilers.uniq
      end
    end
  end
end

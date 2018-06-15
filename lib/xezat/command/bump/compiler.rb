require 'xezat'

module Xezat
  module Command
    class Bump
      def get_compilers(languages, variables)
        LOG.debug('Collect compilers')
        compiler_file = File.expand_path(File.join(DATA_DIR, 'compilers.json'))
        compiler_candidates = JSON.parse(File.read(compiler_file))
        compilers = []
        languages.uniq.each do |language|
          next unless compiler_candidates.key?(language)
          compiler_candidate = compiler_candidates[language]
          if compiler_candidate['package'] == 'python'
            pkg_names = variables[:PKG_NAMES] || variables[:PN]
            if pkg_names.include?('python3-')
              compilers << :'python3'
            elsif pkg_names.include?('pypi-')
              compilers << :'pypi'
            else
              compilers << compiler_candidate['package'].intern
            end
          else
            compilers << compiler_candidate['package'].intern
          end
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

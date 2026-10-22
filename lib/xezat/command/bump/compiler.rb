# frozen_string_literal: true

require 'find'
require 'open3'
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

      # Infers compilers from the built packages instead of source file extensions:
      # from the languages recorded in their debuginfo, or, without debuginfo,
      # from the kinds of files they ship
      def get_compilers_from_files(variables, runtimes, pkg2files)
        languages = get_languages_from_debuginfo(variables)
        if languages.empty?
          files = pkg2files.values.flatten
          languages << :C if files.any? { |file| file.end_with?('.exe', '.dll', '.a', '.so') }
          languages << :Fortran unless runtimes.grep(/^libgfortran/).empty? && files.grep(/\.mod$/).empty?
        end
        get_compilers(languages, nil)
      end

      # Languages of the compile units built from the package's own source
      # (/usr/src/debug/${PF}); the Cygwin startup code and libgcc linked into
      # every executable come from elsewhere and are left out
      def get_languages_from_debuginfo(variables)
        Xezat.logger.debug('  Collect languages from debuginfo')
        debug_dir = File.join(variables[:D], 'usr', 'lib', 'debug')
        return [] unless FileTest.directory?(debug_dir)

        src_dir = "/usr/src/debug/#{variables[:PF]}/"
        languages = []
        Find.find(debug_dir) do |file|
          next unless file.end_with?('.dbg')

          parse_compile_units(invoke_objdump_dwarf(file)).each do |unit|
            next if unit[:name].nil?

            path = unit[:name].start_with?('/') ? unit[:name] : File.join(unit[:comp_dir].to_s, unit[:name])
            next unless path.start_with?(src_dir)

            language = compile_unit_language(unit)
            languages << language unless language.nil?
          end
        end
        languages.uniq
      end

      def invoke_objdump_dwarf(file)
        result, error, status = Open3.capture3('objdump', '--dwarf=info', '--dwarf-depth=1', file)
        unless status.success?
          Xezat.logger.warn("    objdump failed for #{file}: #{error}")
          return ''
        end
        result
      rescue SystemCallError => e
        Xezat.logger.warn("    objdump failed for #{file}: #{e.message}")
        ''
      end

      def parse_compile_units(dump)
        units = []
        dump.each_line do |line|
          if line.include?('(DW_TAG_compile_unit)')
            units << {}
          elsif !units.empty? && (match = line.match(/DW_AT_(producer|language|name|comp_dir)\s*:\s*(.*)$/))
            # Strip the form of an indirect string, e.g. "(indirect line string, offset: 0x0): "
            units.last[match[1].to_sym] ||= match[2].sub(/\A\([^)]*\):\s*/, '').strip
          end
        end
        units
      end

      def compile_unit_language(unit)
        language = unit[:language].to_s[/\((.*)\)/, 1].to_s
        producer = unit[:producer].to_s
        if language.include?('C++') || producer.start_with?('GNU C++')
          :'C++'
        elsif language.match?(/fortran/i) || producer.start_with?('GNU Fortran', 'GNU F77')
          :Fortran
        elsif language.match?(/\A(ANSI |non-ANSI )?C\d*\z/) || producer.match?(/\AGNU C\d*\s/)
          :C
        end
      end
    end
  end
end

require 'facets/file/atomic_write'
require 'find'
require 'json'
require 'xezat'
require 'xezat/cygchangelog'
require 'xezat/cygclasses'
require 'xezat/detectors'
require 'xezat/ext/linguist/file_blob'
require 'xezat/packages'
require 'xezat/variables'

module Xezat

  class FilePermissionError < StandardError
  end

  class IllegalStateError < StandardError
  end

  module Command
    class Bump
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        pkgs = packages()
        vars = variables(@cygport)
        readme_file = File.expand_path(File.join(vars[:C], 'README'))

        info = {
            src_uri: get_src_uri(vars),
            runtimes: get_runtime_packages(@cygport),
            developments: get_development_packages(vars, pkgs),
            files: get_files(vars),
            changelog: get_changelog(vars, @options, readme_file)
        }

        File.atomic_write(readme_file) do |f|
          f.write(get_embedded_contents(vars, info))
        end
      end


      def get_src_uri(vars, cygclasses = CygclassManager.new)
        cygclasses.vcs.each do |vcs|
          next unless vars.key?("_#{vcs}_CYGCLASS_".intern)
          src_uri_key = "#{vcs.to_s.upcase}_URI".intern
          return vars[src_uri_key].split if vars.key?(src_uri_key)
        end
        vars[:SRC_URI].split
      end


      def get_runtime_packages(cygport)
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3(command.join(' '))
        raise CygportProcessError, error unless status.success?
        result.gsub!(/^.*\*\*\*.*$/, '')
        result.split($INPUT_RECORD_SEPARATOR).map!(&:lstrip)
      end


      def get_development_packages(variables, packages)
        compilers = get_compilers(get_languages(variables[:S]), variables)
        tools = get_tools(variables)
        development_packages = (compilers + tools + [:cygport]).uniq.sort
        development_packages.map! do |package|
          packages[package] || ''
        end
      end

      def get_compilers(languages, variables)
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

      def get_languages(top_src_dir)
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
        languages
      end

      def get_tools(variables)
        DetectorManager.new().detect(variables)
      end

      def get_files(variables)
        pkg2files = {}
        variables[:pkg_name].each do |pkg_name|
          lst_file = File.expand_path(File.join(variables[:T], ".#{pkg_name}.lst"))
          raise IllegalStateError, "No such file: #{lst_file}" unless FileTest.readable?(lst_file)
          lines = File.readlines(lst_file)
          lines.delete_if do |path|
            path.strip!
            path[-1] == File::SEPARATOR # ignore directory
          end.map! do |path|
            File::SEPARATOR + path
          end
          if variables[:PN] == pkg_name
            readme = File::SEPARATOR + File.join('usr', 'share', 'doc', 'Cygwin', "#{pkg_name}.README")
            lines << readme.strip unless lines.include?(readme)
          end
          pkg2files[pkg_name.intern] = lines.sort
        end
        pkg2files
      end

      def get_changelog(variables, options, readme_file)
        current_version = variables[:PVR].intern
        if FileTest.exist?(readme_file)
          raise FilePermissionError, "Cannot read #{readme_file}" unless FileTest.readable?(readme_file)
          raise FilePermissionError, "Cannot write #{readme_file}" unless FileTest.writable?(readme_file)
          changelog = Cygchangelog.new(File.read(readme_file))
          message = options['message'] || 'Version bump.'
          changelog[current_version] = message unless changelog.key?(current_version)
        else
          changelog = Cygchangelog.new
          changelog[current_version] = 'Initial release by fd0 <https://github.com/fd00/>'
        end
        changelog
      end

      def get_embedded_contents(variables, info)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'README.erb'))
        ERB.new(File.readlines(erb).join(nil), nil, '%-').result(binding).chop # remove redundant new line
      end
    end
  end
end

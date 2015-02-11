require 'erb'
require 'facets/file/atomic_write'
require 'find'
require 'fileutils'
require 'xezat'
require 'xezat/commands'
require 'xezat/cygchangelog'
require 'xezat/cygclasses'
require 'xezat/detectors'
require 'xezat/refine/linguist/file_blob'
require 'xezat/packages'
require 'xezat/variables'

module Xezat
  # ファイルのパーミッションが適切でない場合に投げられる例外
  class FilePermissionError < StandardError
  end

  # cygport の他のコマンドが終わっておらずに呼び出すべき状態ではない場合に投げられる例外
  class IllegalStateError < StandardError
  end

  module Command
    # README を生成または更新する
    class Bump
      def initialize(program)
        program.command(:bump) do |c|
          c.syntax 'bump cygport'
          c.description 'update CYGWIN-PATCHES/README'
          c.option 'message', '-m', '--message message', String, 'specify changelog message'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager::register(:bump, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args.to_s}" unless args.empty?

        variables = VariableManager::get_default_variables(cygport)
        packages = PackageManager::get_installed_packages()
        readme_file = File::expand_path(File::join(variables[:C], 'README'))

        info = {}
        info[:src_uri] = get_src_uri(variables)
        info[:runtimes] = get_runtime_packages(cygport)
        info[:developments] = get_development_packages(variables, packages)
        info[:files] = get_files(variables)
        info[:changelog] = get_changelog(variables, options, readme_file)

        File::atomic_write(readme_file) do |f|
          f.write(get_embedded_contents(variables, info))
        end
      end

      # changelog を取得する
      def get_changelog(variables, options, readme_file)
        current_version = variables[:PVR].intern
        if FileTest::exist?(readme_file)
          raise FilePermissionError, "Cannot read #{readme_file}" unless FileTest::readable?(readme_file)
          raise FilePermissionError, "Cannot write #{readme_file}" unless FileTest::writable?(readme_file)
          changelog = Cygchangelog.new(File::read(readme_file))
          options['message'] ||= 'Version bump.'
          changelog[current_version] = options['message'] unless changelog.key?(current_version)
        else
          changelog = Cygchangelog.new
          changelog[current_version] = 'Initial release by fd0 <https://github.com/fd00/>'
        end
        changelog
      end

      # vcs に対応した SRC_URI を取得する
      def get_src_uri(variables, cygclass_manager = CygclassManager.new)
        cygclass_manager.vcs.each do |vcs|
          src_uri_key = "#{vcs.to_s.upcase}_URI".intern
          return variables[src_uri_key].split if variables.key?(src_uri_key)
        end
        variables[:SRC_URI].split
      end

      # package が依存している runtime のリストを取得する
      def get_runtime_packages(cygport)
        command = ['bash', File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')), cygport]
        result, error, status = Open3.capture3(command.join(' '))
        raise CygportProcessError, error unless status.success?
        result.split($/).map! do |runtime|
          runtime.lstrip
        end
      end

      # package を build するために必要な development package のリストを取得する
      def get_development_packages(variables, packages)
        compilers = get_compilers(variables)
        tools = get_tools(variables)
        development_packages = (compilers + tools + [:cygport]).uniq.sort
        development_packages.map! do |package|
          packages[package] || ''
        end
      end

      # package を build するために必要な compiler package のリストを取得する
      def get_compilers(variables)

        # ファイルの内容からプログラミング言語を特定する
        languages = []
        Find::find(variables[:S]) do |path|
          unless FileTest::directory?(path)
            language = Xezat::Refine::Linguist::FileBlob.new(path).language
            unless language.nil?
              name = language.name
              if name == 'Objective-C' # Objective-C は誤検知があるため suffix で再確認
                next unless path.end_with?('.m')
              end
              if name == 'Ruby' # Ruby は誤検知があるため suffix で再確認
                next unless path.end_with?('.rb')
              end
              if name == 'C++' # C++ は誤検知があるため suffix で再確認
                name = 'C' if path.end_with?('.h')
              end
              languages << name
            end
          end
        end

        # 言語から対応する compiler package を取得する
        compiler_file = File.expand_path(File.join(DATA_DIR, 'compilers.json'))
        compiler_candidates = JSON.parse(File::read(compiler_file))
        compilers = []
        languages.uniq.each do |language|
          if compiler_candidates.key?(language)
            compiler_candidate = compiler_candidates[language]
            compilers << compiler_candidate['package'].intern
            if compiler_candidate.key?('dependencies')
              compiler_candidate['dependencies'].each do |dependency|
                compilers << dependency.intern
              end
            end
          end
        end
        compilers.uniq
      end

      # packages を build するために必要な tool package のリストを取得する
      def get_tools(variables)
        DetectorManager::load_default_detectors
        DetectorManager::detect(variables)
      end

      # package で生成されるチェック用の *.lst から README に埋め込むファイルのリストを取得する
      def get_files(variables)
        pkg2files = {}
        variables[:pkg_name].each do |pkg_name|
          lst_file = File::expand_path(File::join(variables[:T], ".#{pkg_name}.lst"))
          raise IllegalStateError, "No such file: #{lst_file}" unless FileTest::readable?(lst_file)
          lines = File::readlines(lst_file)
          lines.delete_if do |path|
            path.strip!
            path[-1] == File::SEPARATOR
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

      # テンプレートにデータを埋め込んだ結果の文字列を取得する
      def get_embedded_contents(variables, info)
        erb = File::expand_path(File::join(TEMPLATE_DIR, 'README.erb'))
        ERB.new(File::readlines(erb).join(nil), nil, '%-').result(binding)
      end
    end
  end
end

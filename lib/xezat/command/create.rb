require 'erb'
require 'facets/file/atomic_write'
require 'json'
require 'xezat/commands'
require 'xezat/cygclasses'

module Xezat
  # 指定された repository が存在しない場合に投げられる例外
  class NoSuchRepositoryError < StandardError
  end

  # cygport を上書き許可なしで上書きしようとした場合に投げられる例外
  class UnoverwritableConfigurationError < StandardError
  end

  # 指定された cygclass が存在しない場合に投げられる例外
  class NoSuchCygclassError < StandardError
  end

  # VCS が複数指定された場合に投げられる例外
  class CygclassConflictError < StandardError
  end

  module Command
    # 新しい cygport ファイルを生成する
    class Create
      def initialize(program)
        program.command(:create) do |c|
          c.syntax 'create [options] cygport'
          c.description 'create new cygport'
          c.option 'apponly', '-a', '--app-only', 'application only'
          c.option 'category', '-c', '--category category', String, 'specify category'
          c.option 'description', '-d', '--description description', String, 'specify description'
          c.option 'inherit', '-i', '--inherit cygclass', Array, 'inherit cygclasses'
          c.option 'overwrite', '-o', '--overwrite', 'overwrite cygport'
          c.option 'repository', '-r', '--repository repository', String, 'specify repository (github, google, sourceforge)'
          c.option 'summary', '-s', '--summary summary', String, 'specify summary'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager.register(:create, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args}" unless args.empty?

        repository_variables = get_repository_variables(options['repository'])

        raise UnoverwritableConfigurationError, "#{cygport} already exists" if File.exist?(cygport) && !options['overwrite']

        cygclasses = options['inherit'] || []
        template_variables = get_template_variables(repository_variables, CygclassManager.new, cygclasses)
        File.atomic_write(cygport) do |f|
          f.write(get_cygport(template_variables, options['category'], options['summary'], options['description'], options['apponly'], cygclasses, cygport))
        end
      end

      # repository からデフォルトのシェル変数群を取得する
      def get_repository_variables(repository)
        if repository
          repository_file = File.expand_path(File.join(REPOSITORY_DIR, "#{repository}.json"))
          if FileTest.exists?(repository_file) && FileTest.readable?(repository_file)
            repository_variables = JSON.parse(File.read(repository_file), symbolize_names: true)
          else
            raise NoSuchRepositoryError, "No such repository: #{template}"
          end
        else
          {
            HOMEPAGE: '',
            SRC_URI: ''
          }
        end
      end

      # 他のパラメータからテンプレートに埋め込むシェル変数群を取得する
      def get_template_variables(original_template_variables, cygclass_manager, cygclasses)
        vcs_class = nil
        vcs_prefix = 'SRC'
        cygclasses.each do |cygclass|
          raise NoSuchCygclassError, "No such cygclass: #{cygclass}" unless cygclass_manager.include?(cygclass.intern)
          if cygclass_manager.vcs?(cygclass.intern)
            raise CygclassConflictError, "#{cygclass} conflict with #{vcs_class}" if vcs_class
            vcs_class = cygclass
          end
        end
        vcs_prefix = vcs_class.to_s.upcase if vcs_class
        vcs_uri = "#{vcs_prefix}_URI".intern
        {
          :HOMEPAGE => original_template_variables[:HOMEPAGE],
          vcs_uri => original_template_variables[vcs_uri]
        }
      end

      # シェル変数群を埋め込まれたテンプレート文字列を返す
      def get_cygport(template_variables, category, summary, description, apponly, cygclasses, cygport)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'cygport.erb'))
        ERB.new(File.readlines(erb).join(nil), nil, '%-').result(binding)
      end
    end
  end
end

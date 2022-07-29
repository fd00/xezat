# frozen_string_literal: true

require 'facets/file/atomic_write'
require 'json'
require 'xezat/config'
require 'xezat/cygclasses'

module Xezat
  class NoSuchRepositoryError < StandardError
  end

  class UnoverwritableCygportError < StandardError
  end

  class NoSuchCygclassError < StandardError
  end

  class CygclassConflictError < StandardError
  end

  module Command
    class Init
      include Xezat

      def initialize(options, cygport)
        @options = options
        @cygport = cygport
      end

      def execute
        cygclass_dir = config(@options[:config])['cygwin']['cygclassdir']
        repository_variables = get_repository_variables(@options['repository'])
        raise UnoverwritableCygportError, "#{@cygport} already exists" if FileTest.exist?(@cygport) && !@options['overwrite']

        cygclasses = (@options['inherit'] || '').split(',')
        template_variables = get_template_variables(repository_variables, CygclassManager.new(cygclass_dir), cygclasses)
        File.atomic_write(@cygport) do |f|
          f.write(get_cygport(template_variables, @options['category'], @options['summary'], @options['description'], cygclasses, @cygport))
        end
      end

      def get_repository_variables(repository)
        if repository
          repository_file = File.expand_path(File.join(REPOSITORY_DIR, "#{repository}.yaml"))
          raise NoSuchRepositoryError, "No such repository: #{template}" unless FileTest.exist?(repository_file) || FileTest.readable?(repository_file)

          YAML.safe_load(File.open(repository_file), symbolize_names: true)
        else
          {
            HOMEPAGE: '',
            SRC_URI: ''
          }
        end
      end

      def get_template_variables(original_template_variables, cygclass_manager, cygclasses)
        vcs_class = nil
        vcs_prefix = 'SRC'
        cygclasses.each do |cygclass|
          raise NoSuchCygclassError, "No such cygclass: #{cygclass}" unless cygclass_manager.include?(cygclass.intern)

          next unless cygclass_manager.vcs?(cygclass.intern)
          raise CygclassConflictError, "#{cygclass} conflict with #{vcs_class}" if vcs_class

          vcs_class = cygclass
        end
        vcs_prefix = vcs_class.to_s.upcase if vcs_class
        vcs_uri = "#{vcs_prefix}_URI".intern
        {
          :HOMEPAGE => original_template_variables[:HOMEPAGE],
          vcs_uri => original_template_variables[vcs_uri]
        }
      end

      def get_cygport(template_variables, category, summary, description, cygclasses, cygport)
        erb = File.expand_path(File.join(TEMPLATE_DIR, 'cygport.erb'))
        ERB.new(File.readlines(erb).join(nil), trim_mode: '%-').result(binding)
      end
    end
  end
end

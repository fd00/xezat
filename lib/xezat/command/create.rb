
require 'json'

require 'xezat/xezat'
require 'xezat/commands'
require 'xezat/cygclasses'

module Xezat

  # create *.cygport from templates
  class Create < Command

    Commands.register(:create, self)

    # for test
    attr_writer :cygclass_manager, :template_variables
    
    def initialize
      super(:create, 'PKG-VER-REL.cygport')
      @help = false
      @cygclasses = []
      @overwrite = false
      @cygclass_manager = CygclassManager.new
      @ignored = nil
      @template_variables = {}
      @category = ''

      @op.on('-c', '--category=VAL', 'Select category', Array) { |v|
        @category = v.map! { |category|
          category.intern
        }.uniq.join(' ')
      }
      @op.on('-i', '--inherit=VAL', 'Select cygclasses to inherit', Array) { |v|
        @cygclasses = v.map! { |cygclass|
          cygclass.intern
        }.uniq
      }
      @op.on('-o', '--overwrite', 'Overwrite cygport file', TrueClass) { |v|
        @overwrite = true
      }
      @op.on('-t', '--template=VAL', 'Select template (berlios/github/google/sourceforge)') { |v|
        template_file = File.expand_path(File.join(DATA_DIR, 'repository', v + '.json'))
        if FileTest::exists?(template_file) && FileTest::readable?(template_file)
          @template_variables = JSON.parse(File::read(template_file), {:symbolize_names => true})
        else
          raise NoSuchTemplateException, "cannot use #{v}: No such template"
        end
      }
    end
    
    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      cygport = comp(argv.shift)
      ignored = argv # TODO 捨てたことがわかるようにしたい
      
      if File::exist?(cygport) && !@overwrite
        raise UnoverwritableConfigurationException,
          "#{cygport} already exists"
      end
      
      template_variables = get_template_variables(@cygclasses)
      contents = get_cygport(template_variables, @category, @cygclasses)
      tmp_file = File.expand_path(File.join(Dir.tmpdir(), SecureRandom.uuid))
      Signal.trap(:INT) {
        FileUtils.remove(tmp_file)
      }
      File.open(tmp_file, 'w') { |f|
        f << contents
      }
      FileUtils.move(tmp_file, cygport)
    end
    
    # テンプレートに基づく変数を決定する
    def get_template_variables(cygclasses)
      fetcher_class = nil
      fetcher_prefix = 'SRC'
      cygclasses.each { |cygclass|
        unless @cygclass_manager.exists?(cygclass)
          raise NoSuchCygclassException,
            "cannot inherit #{cygclass}: No such cygclass"
        end
        if @cygclass_manager.fetcher?(cygclass)
          if fetcher_class
            raise CygclassConflictException,
              "cannot inherit #{cygclass}: #{cygclass} conflict with #{fetcher_class}"
          else
            fetcher_class = cygclass
          end
        end
      }
      if fetcher_class
        fetcher_prefix = fetcher_class.to_s.upcase
      end
      key = (fetcher_prefix + '_URI').intern
      {
        :HOMEPAGE => @template_variables[:HOMEPAGE],
        key => @template_variables[key],
      }
    end
    
    def get_cygport(template_variables, category, cygclasses)
      readme_erb = File.expand_path(File.join(PATCHES_TEMPLATE_DIR, 'cygport.erb'))
      ERB.new(File.readlines(readme_erb).join(nil), nil, '%-').result(binding)
    end
    
  end

end

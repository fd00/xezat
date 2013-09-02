
require 'xezat/xezat'
require 'xezat/commands'
require 'xezat/cygclasses'

module Xezat

  # cygport の骨組みを生成するコマンド
  class Create < Command

    Commands.register(:create, self)

    # SRC_URI を内部で書き換える cygclass
    EXTENDED_FETCHER_CLASSES = [
      :cvs, :svn, :git, :bzr, :hg, :mtn, :fossil,
    ]

    # TODO yaml か何かで設定ファイルから読み込むようにしたい
    TEMPLATE_MAP = {
      :sourceforge => {
        :HOMEPAGE => 'http://${PN}.sf.net/',
        :SRC_URI  => 'mirror://sourceforge/${PN}/${P}.tar.gz',
      },
      :google => {
        :HOMEPAGE => 'https://code.google.com/p/${PN}/',
        :SRC_URI  => 'https://${PN}.googlecode.com/files/${P}.tar.gz',
      },
      :berlios => {
        :HOMEPAGE => 'http://${PN}.berlios.de/',
        :SRC_URI  => 'mirror://berlios/${PN}/${P}.tar.gz',
      },
    }
    TEMPLATE_MAP.default = {
      :HOMEPAGE => '',
      :SRC_URI  => '',
    }

    # for test
    attr_writer :cygclass_manager

    def initialize
      super(:create, 'PKG-VER-REL.cygport')
      @help = false
      @variables = {
        :CATEGORY => '',
        :SUMMARY => '',
        :DESCRIPTION => '',
      }
      @variables.merge!(TEMPLATE_MAP.default)
      @cygclasses = []
      @overwrite = false
      @cygclass_manager = CygclassManager.new
      @ignored = nil

      @op.on('-c', '--category=VAL', 'Select category', Array) { |v|
        @variables[:CATEGORY] = v.map! { |category|
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
      @op.on('-t', '--template=VAL', 'Select template (sourceforge/google)') { |v|
        vi = v.intern
        if TEMPLATE_MAP.has_key?(vi)
          @variables.merge!(TEMPLATE_MAP[vi])
        else
          raise NoSuchTemplateException, "cannot use #{v}: No such template"
        end
      }
    end

    def run(argv)
      begin
        parse(argv)
      rescue NoSuchTemplateException => e
        puts 'xezat-create: ' + e.to_s
        return
      end

      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      if argv.length == 0
        raise IllegalArgumentOfCommandException, 'cygport not specified'
      end
      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい

      begin
        generate(cygport, @overwrite, @variables, @cygclasses)
      rescue UnoverwritableConfigurationException,
             NoSuchCygclassException,
             CygclassConflictException => e
        puts "xezat-create: " + e.to_s
        return
      end
    end

    # SRC_URI を必要に応じて vcs cygclass の値に書き換える
    def resolve(cygclasses, variables)
      fetcher_class = nil
      cygclasses.each { |cygclass|
        unless @cygclass_manager.exists?(cygclass)
          raise NoSuchCygclassException,
            "cannot inherit #{cygclass}: No such cygclass"
        end
        if EXTENDED_FETCHER_CLASSES.include?(cygclass)
          if fetcher_class
            raise CygclassConflictException,
              "cannot inherit #{cygclass}: #{cygclass} conflict with #{fetcher_class}"
          else
            variables.delete(:SRC_URI)
            variables[(cygclass.to_s.upcase + '_URI').intern] = ''
            fetcher_class = cygclass
          end
        end
      }
    end

    # variables と cygclasses を buf に整形する
    def create(variables, cygclasses)
      buf = []
      variables.each { |k, v|
        buf << k.to_s + '="' + v + '"'
      }
      buf << ''
      cygclasses.each { |cygclass|
        buf << 'inherit ' + cygclass.to_s
      }
      buf << ''
    end

    # buf の内容を cygport に書き出す
    def write(fp, buf)
      fp.write(buf.join($/))
    end

    # cygport ファイルを生成する
    def generate(cygport, overwrite, variables, cygclasses)
      if File.exist?(cygport)
        unless overwrite
          raise UnoverwritableConfigurationException,
            "#{cygport} already exists"
        end
      end
      resolve(cygclasses, variables)
      File.open(cygport, 'w') { |fp|
        write(fp, create(variables, cygclasses))
      }
    end

    # 渡された引数を解析する
    def parse(argv)
      @op.order!(argv)
    end

  end

end

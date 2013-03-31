
require 'erb'
require 'yacptool/yacptool'
require 'yacptool/commands'
require 'yacptool/detectors'
require 'yacptool/packages'
require 'yacptool/variables'

module Yacptool

  # CYGWIN-PATCHES の骨組みを生成するクラス
  class Patches < Command

    Commands.register(:patches, self)

    def initialize
      super(:patches, 'PKG-VER-REL.cygport')
      @overwrite = false
      @op.on('-o', '--overwrite', 'Overwrite cygport file', TrueClass) { |v|
        @overwrite = true
      }
    end

    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい

      # PKG_NAMES から hint を抽出する
      variables = VariableManager.get_default_variables(cygport)
      if variables.exists?(:PKG_NAMES)
        pkg_names = extract_hints(variables[:PKG_NAMES])
      else
        pkg_names = ['setup']
      end
      file_names = pkg_names.map { |pkg_name| pkg_name + '.hint' }

      # *.hint を生成する
      bodies = {} # <absolute_path, text>
      hint_erb = File.expand_path(File.join(PATCHES_TEMPLATE_DIR, 'hint.erb'))
      file_names.each { |file_name|
        bodies[File.expand_path(File.join(variables[:C], file_name)).intern] =
          ERB.new(IO.readlines(hint_erb).join(nil), nil, '%-').result(binding)
      }
      
      # README に埋め込む変数を取得する
      runtimes = get_runtimes(cygport)
      builds = get_builds(variables[:S], PackageManager.get_default_packages)

      # ${PN}.README を生成する
      src_uri = get_src_uri(variables)
      readme_erb = File.expand_path(File.join(PATCHES_TEMPLATE_DIR, 'README.erb'))
      bodies[File.expand_path(File.join(variables[:C], 'README')).intern] =
        ERB.new(IO.readlines(readme_erb).join(nil), nil, '%-').result(binding)

      # CYGWIN-PATCHES にファイルを生成する
      generate(bodies, @overwrite)
    end
    
    # runtime requirements を抽出する
    def get_runtimes(cygport)
      command = File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')) + ' ' + cygport
      result, error, status = Open3.capture3(command)
      unless status.success?
        raise CygportProcessException, error
      end
      result.split(/\n/).map! { |runtime| runtime.lstrip }
    end
    
    # build requirements を抽出する
    def get_builds(root, package_manager)
      Detectors.get_components(root).map! { |detector|
        package_manager[detector]
      }
    end
    
    # ダンプした変数文字列から空白文字区切りの配列を抽出する
    # 内部に制御文字を含んでいる場合は $ が先頭にある (っぽい)
    def extract_hints(str)
      str.gsub(/^\$/, '').gsub(/^'/, '').gsub(/'$/, '').strip.split(/\\n|\\t| /).
        delete_if { |value| value.empty? }
    end

    # 継承している VCS に応じた SRC_URI を返す
    def get_src_uri(variables)
      unless src_uri = variables[:SRC_URI]
        raise IllegalArgumentException, ':SRC_URI not defined'
      end
      variables.each { |key, value|
        if key.to_s.match(/^\w+_URI$/)
          unless (key == :SRC_URI || key == :PATCH_URI)
            src_uri = value
            break # TODO 複数ある場合を考慮してないけどいいか？
          end
        end
      }
      src_uri
    end

    # *.hint および README を生成する
    def generate(bodies, overwrite)
      bodies.each { |file_name, body|
        dest = file_name.to_s
        unless Dir.exists?(File.dirname(dest))
          raise IllegalStateException,
            'CYGWIN-PATCHES directory not found'
        end
        if File.exists?(dest)
          unless overwrite
            raise UnoverwritableConfigurationException,
              "#{File.basename(dest)} already exists"
          end
        end
        File.open(dest, 'w') { |fp|
          fp.puts body
        }
      }
    end

    # 複数行からなる src_uri を分割して先頭のみを取り出す
    def split(value)
      if value.match(/^\$/)
        values = value.split(/\s+/)
        values[1]
      else
        value
      end
    end

  end

end

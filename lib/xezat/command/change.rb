
require 'erb'
require 'securerandom'
require 'tmpdir'

require 'xezat/xezat'
require 'xezat/commands'
require 'xezat/detectors'
require 'xezat/packages'
require 'xezat/readme'
require 'xezat/variables'

module Xezat

  # CYGWIN-PATCHES/README を生成または更新する
  class Change < Command

    Commands.register(:change, self)
    
    def initialize
      super(:change, 'PKG-VER-REL.cygport')
      @message = 'Version bump.'
      @op.on('-m', '--message=VAL', 'Set changelog message') { |v|
        @message = v
      }
    end
    
    def run(argv)
      
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end
      
      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい

      variables = VariableManager.get_default_variables(cygport)
      readme_file = File.expand_path(File.join(variables[:C], 'README'))
      if FileTest.exists?(readme_file)
        if FileTest.readable?(readme_file)
          readme = Readme.new(File.read(readme_file))
          version = variables[:PVR].intern
          unless readme.exists?(version)
            readme[version] = @message
          end
        else
          raise FilePermissionException, "cannot read #{readme_file}"
        end
      else
        readme = Readme.new('')
        version = variables[:PVR].intern
        readme[version] = INITIAL_RELEASE_MESSAGE
      end

      if FileTest.exists?(readme_file)
        unless FileTest.writable?(readme_file)
          raise FilePermissionException, "cannot write #{readme_file}"
        end
      end
            
      info = {}
      info[:runtimes] = get_runtimes(cygport)
      info[:builds] = get_builds(variables, PackageManager.get_default_packages)
      info[:src_uri] = get_src_uri(variables)
      info[:changelog] = readme
      files = get_files(variables)
      contents = get_readme(variables, info, files)
      tmp_file = File.expand_path(File.join(Dir.tmpdir(), SecureRandom.uuid))
      Signal.trap(:INT) {
        FileUtils.remove(tmp_file)
      }
      File.open(tmp_file, 'w') { |f|
        f << contents
      }
      FileUtils.move(tmp_file, readme_file)
    end
    
    def get_runtimes(cygport)
      command = File.expand_path(File.join(DATA_DIR, 'invoke_cygport_dep.sh')) + ' ' + cygport
      result, error, status = Open3.capture3(command)
      unless status.success?
        raise CygportProcessException, error
      end
      result.split(/\n/).map! { |runtime| runtime.lstrip }
    end
    
    def get_builds(variables, package_manager)
      Detectors.get_components(variables).map! { |detector|
        package_manager[detector]
      }
    end
    
    def get_src_uri(variables)
      unless src_uri = variables[:SRC_URI]
        raise IllegalArgumentException, ':SRC_URI not defined'
      end
      variables.each { |key, value|
        if key.to_s.match(/^[A-Z]+_URI$/)
          unless (key == :SRC_URI || key == :PATCH_URI)
            src_uri = value
            break # TODO 複数ある場合を考慮してないけどいいか？
          end
        end
      }
      src_uri
    end
    
    def get_files(variables)
      files = {}
      dir = variables[:T]
      variables[:pkg_name].each { |pkg_name|
        lst_file = File.expand_path(File.join(dir, '.' + pkg_name + '.lst'))
        if FileTest.readable?(lst_file)
          lines = File.readlines(lst_file)
          lines.delete_if { |path| path.strip[-1] == '/' }.map! { |path| '/' + path }
          files[pkg_name.intern] = lines
        else
          raise
        end
      }
      files
    end
    
    def get_readme(variables, info, files)
      readme_erb = File.expand_path(File.join(PATCHES_TEMPLATE_DIR, 'README.erb'))
      ERB.new(File.readlines(readme_erb).join(nil), nil, '%-').result(binding)
    end
    
  end
  
end

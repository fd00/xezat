
require 'yacptool/yacptool'
require 'yacptool/commands'
require 'yacptool/detectors'

module Yacptool

  # build requirements を表示する
  class Builds < Command

    Commands.register(:builds, self)
    
    def initialize
      super(:builds, 'PKG-VER-REL.cygport')
    end
    
    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      cygport = argv.shift
      ignored = argv # TODO 捨てたことがわかるようにしたい
      
      variables = VariableManager.get_default_variables(cygport)
      get_builds(variables[:S], PackageManager.get_default_packages).each { |build|
        puts "  #{build}"
      }
    end
    
    # build requirements を抽出する
    def get_builds(root, package_manager)
      Detectors.get_components(root).map! { |detector|
        package_manager[detector]
      }
    end
  end
  
end
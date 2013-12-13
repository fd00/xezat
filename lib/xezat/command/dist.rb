
require 'rbzip2'

require 'erb'
require 'securerandom'
require 'tmpdir'

require 'xezat/xezat'
require 'xezat/commands'
require 'xezat/hint'

module Xezat

  # dist 配下を公開領域に移動 & setup.bz2 を生成する
  class Dist < Command

    Commands.register(:dist, self)

    def initialize
      super(:dist, 'PKG-VER-REL.cygport')
      
      @dryrun = false
      @machine = machine = 'x86'
      @rootdir = rootdir = File.expand_path(File.join('srv', 'www', 'htdocs'), '/')
      @verbose = false
      
      @op.on('-d', '--dry-run', "Don't modify anything", TrueClass) { |v|
        @dryrun = true
      }
      @op.on('-m', '--machine=VAL', "Select machine (default:#{machine})") { |v|
        unless v == 'x86' || v == 'x86_64'
          raise IllegalArgumentOfCommandException, 'Illegal machine : ' + v
        end
        @machine = v
      }
      @op.on('-r', '--rootdir=VAL', "Select setup root directory (default:#{rootdir})") { |v|
        unless FileTest.directory?(v)
          raise IllegalArgumentOfCommandException, 'Illegal rootdir : ' + v
        end
        @rootdir = v
      }
      @op.on('-v', '--verbose', 'Explain what is being done') { |v|
        @verbose = true
      }
    end
    
    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      cygport = comp(argv.shift)
      ignored = argv # TODO 捨てたことがわかるようにしたい
      
      option = {}
      if @dryrun
        option[:noop] = true
        option[:verbose] = true
      end
      if @verbose
        option[:verbose] = true
      end
      
      # dist 配下を repository にコピー
      variables = VariableManager.get_default_variables(cygport)
      release = File.expand_path(File.join(@rootdir, @machine, 'release'))
      FileUtils.makedirs(release, option)
      FileUtils.cp_r(File.expand_path(File.join(variables[:distdir], variables[:PN])), release, option)
      
      # setup.bz2 を生成
      hints = HintManager.new(File.join(@rootdir, @machine))
      contents = get_ini(hints)
      tmp_file = File.expand_path(File.join(Dir.tmpdir(), SecureRandom.uuid))
      Signal.trap(:INT) {
        FileUtils.remove(tmp_file)
      }
      bz2 = RBzip2::Compressor.new(File.open(tmp_file, 'w'))
      bz2.write(contents)
      bz2.close
      FileUtils.move(tmp_file, File.join(@rootdir, @machine, 'setup.bz2'), option)
    end
    
    def get_ini(hints, timestamp = Time.now.to_i)
      setup_erb = File.expand_path(File.join(PATCHES_TEMPLATE_DIR, 'setup.erb'))
      ERB.new(File.readlines(setup_erb).join(nil), nil, '%-').result(binding)
    end
    
  end
  
end

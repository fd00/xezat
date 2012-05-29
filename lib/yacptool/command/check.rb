
require 'zlib'

require 'yacptool/yacptool'
require 'yacptool/commands'

module Yacptool

  # パッケージ間のファイルの衝突を調べるコマンド
  class Check < Command

    Commands.register(:check, self)

    def initialize
      super(:check)
    end

    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      aggregate.each { |key, value|
        if value.length > 1
          puts "#{key} is contained by multiple packages"
          value.each { |pkg|
            puts "\t#{pkg}"
          }
        end
      }
    end

    def aggregate(path = '/etc/setup')
      file2pkg = {}
      Dir.glob(path + '/*.lst.gz') { |lst|
        pkg = File.basename(lst, '.lst.gz').intern
        Zlib::GzipReader.open(lst) { |gz|
          gz.lines { |line|
            line.strip!
            unless line.end_with?('/')
              path = line.intern
              if file2pkg.key?(path)
                file2pkg[path] << pkg
              else
                file2pkg[path] = [pkg]
              end
            end
          }
        }
      }
      file2pkg
    end

  end

end
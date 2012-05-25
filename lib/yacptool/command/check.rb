
require 'optparse'
require 'zlib'

require 'yacptool/yacptool'
require 'yacptool/commands'

module Yacptool

  class Check

    Commands.register(:check, self)

    def initialize
      @op = OptionParser.new
      @op.banner = 'Usage: yacptool check [option...]'
      @op.on('-?', '--help', 'Show help message', TrueClass) { |v|
        @help = true
      }
    end

    def run(argv)
      @op.order!(argv)
      if @help
        raise IllegalArgumentOfCommandException, 'help specified'
      end

      aggregate('/etc/setup').each { |key, value|
        if value.length > 1
          puts "#{key} is contained by multiple packages"
          value.each { |pkg|
            puts "\t#{pkg}"
          }
        end
      }
    end

    def aggregate(path)
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

    def help
      @op.help
    end

  end

end
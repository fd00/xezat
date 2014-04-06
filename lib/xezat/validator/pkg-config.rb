
require 'find'
require 'xezat/validators'

module Xezat
  
  class PkgConfig < Validator
    
    Validators.register('pkg-config', self)
    
    def validate(variables)
      pcdir = File.join(variables[:D], 'usr', 'lib', 'pkgconfig')
      if Dir.exists?(pcdir)
        Find.find(pcdir) { |file|
          if file.end_with?('.pc')
            print "validate #{File.basename(file)}..."
            File.foreach(file) { |line|
              if line.index('@')
                puts 'NG'
                return
              end
            }
            puts 'OK'
          end
        }
      else
        puts 'validate *.pc... SKIP'
      end
    end

  end
  
end


require 'xezat/validators'

module Xezat
  
  class Aclocal < Validator
    
    Validators.register('aclocal', self)
    
    def validate(variables)
      acdir = File.join(variables[:D], 'usr', 'share', 'aclocal')
      print 'validate m4... '
      if Dir.exists?(acdir)
        command = 'aclocal --system-acdir=' + acdir
        Dir.chdir(variables[:T]) {
          FileUtils.touch('configure.ac')
          result, error, status = Open3.capture3(command)
          if error.empty?
            puts 'OK'
          else
            puts 'NG'
            error.each_line { |line|
              puts line.sub(acdir + '/', '')
            }
          end
        }
      else
        puts 'SKIP'
      end
    end

  end
  
end

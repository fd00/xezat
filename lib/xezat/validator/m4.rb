require 'fileutils'
require 'open3'
require 'xezat/validators'

module Xezat
  module Validator
    # /usr/share/aclocal/*.m4 を検証する
    class M4
      ValidatorManager::register(:m4, self)

      def validate(variables)
        acdir = File::join(variables[:D], 'usr', 'share', 'aclocal')
        detail = nil
        result = nil
        if Dir::exists?(acdir)
          command = ['aclocal', "--system-acdir=#{acdir}"]
          Dir::chdir(variables[:T]) do
            FileUtils::touch('configure.ac')
            stdout, error, status = Open3.capture3(command.join(' '))
            result = error.empty?
            unless result
              detail = error.gsub(acdir + '/', '')
            end
          end
        end
        [result, detail]
      end

    end
  end
end

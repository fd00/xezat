require 'xezat/validators'

module Xezat
  module Validator
    class Pkgconfig
      ValidatorManager::register(:pkgconfig, self)

      def validate(variables)
        pcdir = File::join(variables[:D], 'usr', 'lib', 'pkgconfig')
        result = true
        details = []
        if Dir::exists?(pcdir)
          Find::find(pcdir) do |file|
            if file.end_with?('.pc')
              File::foreach(file) { |line|
                unless line.index('@').nil?
                  result = false
                  details << "#{file.gsub(variables[:D], '')}: contains @"
                  break
                end
                if line.start_with?('Libs:') && line.index(' -l').nil?
                  result = false
                  details << "#{file.gsub(variables[:D], '')}: no library flags found"
                  break
                end
              }
            end
          end
        else
          result = nil
        end
        [result, details.empty? ? nil : details.join($/)]
      end
    end
  end
end

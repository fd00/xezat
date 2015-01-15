require 'xezat/validators'

module Xezat
  module Validator
    class Pkgconfig
      ValidatorManager::register(:pkgconfig ,self)
      def validate(variables)
        pcdir = File::join(variables[:D], 'usr', 'lib', 'pkgconfig')
        result = false
        if Dir::exists?(pcdir)
          Find::find(pcdir) do |file|
            if file.end_with?('.pc')
              result = result || File::open(file).read().index('@').nil?
            end
          end
        else
          result = nil
        end
        [result, nil]
      end
    end
  end
end

module Xezat
  module Detector
    class Meson
      def detect(variables)
        variables.key?(:_meson_CYGCLASS_)
      end
    end
  end
end

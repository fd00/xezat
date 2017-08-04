module Xezat
  module Detector
    class LibQt5CoreDevel
      def detect(variables)
        variables.key?(:_qt5_qmake_CYGCLASS_)
      end
    end
  end
end

# frozen_string_literal: true

module Xezat
  module Detector
    class Libqt5coreDevel
      def detect(variables)
        variables.key?(:_qt5_qmake_CYGCLASS_)
      end
    end
  end
end

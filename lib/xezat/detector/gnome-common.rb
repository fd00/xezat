# frozen_string_literal: true

module Xezat
  module Detector
    class GnomeCommon
      def detect?(variables)
        variables.key?(:_gnome2_CYGCLASS_)
      end
    end
  end
end

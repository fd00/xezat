# frozen_string_literal: true

module Xezat
  module Detector
    class Nasm
      def detect?(variables)
        if variables.key?(:_meson_CYGCLASS_)
          File.foreach(File.join(variables[:S], 'meson.build')) do |line|
            return true if line.include?("find_program('nasm')")
          end
        end
        false
      end
    end
  end
end

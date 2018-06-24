# frozen_string_literal: true

require 'linguist'

module Xezat
  module Linguist
    class FileBlob < ::Linguist::FileBlob
      def data
        super.scrub
      rescue StandardError
        ''
      end
    end
  end
end

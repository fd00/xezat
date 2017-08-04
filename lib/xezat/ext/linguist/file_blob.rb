require 'linguist'

module Xezat
  module Linguist
    class FileBlob < ::Linguist::FileBlob
      def data
        super.scrub
      rescue
        ''
      end
    end
  end
end

require 'linguist'

module Xezat
  module Refine
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
end

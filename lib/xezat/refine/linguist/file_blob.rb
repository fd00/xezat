require 'linguist'
require 'string/scrub' unless String::respond_to?(:scrub)

module Xezat
  module Refine
    module Linguist
      class FileBlob < ::Linguist::FileBlob
        def data
          super.scrub rescue ''
        end
      end
    end
  end
end

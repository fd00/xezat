require 'xezat/refine/linguist/file_blob'

module Xezat::Test::Refine
  module Linguist
    class FileBlobTest < Test::Unit::TestCase
      def test_c
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.c')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("C", language.name)
      end

      def test_cpp
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.cpp')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("C++", language.name)
      end

      def test_fortran
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.f')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("FORTRAN", language.name)
      end

      def test_lex
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.l')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("Lex", language.name)
      end

      def test_objective_c
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.m')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("Objective-C", language.name)
      end

      def test_python
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.py')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("Python", language.name)
      end

      def test_ruby
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.rb')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("Ruby", language.name)
      end

      def test_yacc
        file = File::join(File.dirname(__FILE__), 'fixture', 'xezat.y')
        language = Xezat::Refine::Linguist::FileBlob.new(file).language
        assert_equal("Yacc", language.name)
      end
    end
  end
end

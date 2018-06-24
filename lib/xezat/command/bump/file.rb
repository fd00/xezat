# frozen_string_literal: true

require 'xezat'

module Xezat
  class IllegalStateError < StandardError
  end

  module Command
    class Bump
      def get_files(variables)
        LOG.debug('Collect files')
        pkg2files = {}
        variables[:pkg_name].each do |pkg_name|
          lst_file = File.expand_path(File.join(variables[:T], ".#{pkg_name}.lst"))
          raise IllegalStateError, "No such file: #{lst_file}" unless FileTest.readable?(lst_file)
          lines = File.readlines(lst_file)
          lines.delete_if do |path|
            path.strip!
            path[-1] == File::SEPARATOR # ignore directory
          end
          lines.map! do |path|
            File::SEPARATOR + path
          end
          if variables[:PN] == pkg_name
            readme = File::SEPARATOR + File.join('usr', 'share', 'doc', 'Cygwin', "#{pkg_name}.README")
            lines << readme.strip unless lines.include?(readme)
          end
          pkg2files[pkg_name.intern] = lines.sort
        end
        pkg2files
      end
    end
  end
end

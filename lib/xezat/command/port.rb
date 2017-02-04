require 'fileutils'
require 'inifile'
require 'xezat'
require 'xezat/commands'
require 'xezat/variables'

module Xezat
  # copy 先の git repo が指定されていない場合に投げられる例外
  class NoPortDirectoryError < StandardError
  end

  module Command
    # cygport を git repo に copy する
    class Port
      def initialize(program)
        program.command(:port) do |c|
          c.syntax 'port cygport'
          c.description 'copy cygport to git repository'
          c.option 'verbose', '-V', '--verbose', 'print the results verbosely'
          c.option 'noop', '-n', '--no-operation', 'print the results without actually copying any files'
          c.option 'inifile', '-i', '--inifile *.ini', String, 'specify inifile'
          c.option 'portdir', '-t', '--target portdir', String, 'specify git repository directory'
          c.action do |args, options|
            execute(c, args, options)
          end
        end
      end

      CommandManager.register(:port, self)

      def execute(c, args, options)
        cygport = args.shift
        raise ArgumentError, 'wrong number of arguments (0 for 1)' unless cygport
        c.logger.info "ignore extra arguments: #{args}" unless args.empty?

        variables = VariableManager.get_default_variables(cygport)

        d = File.expand_path(File.join(get_port_directory(options), variables[:PN]))

        fuo = { noop: options.key?('noop'), verbose: options.key?('noop') || options.key?('verbose') }

        FileUtils.mkdir_p(d, fuo)
        FileUtils.cp(File.expand_path(File.join(variables[:top], cygport)), d, fuo)
        FileUtils.cp(File.expand_path(File.join(variables[:C], 'README')), d, fuo)
        src_patch = File.expand_path(File.join(variables[:patchdir], "#{variables[:PF]}.src.patch"))
        FileUtils.cp(src_patch, d, fuo) unless FileTest.zero?(src_patch)
      end

      def get_port_directory(options, xezat_ini_file = INI_FILE)
        d = nil
        inifile = options.key?('inifile') ? options['inifile'] : xezat_ini_file
        ini = IniFile.load(inifile)['xezat']
        d = ini['portdir'] if ini.key?('portdir')
        d = options['portdir'] if options.key?('portdir')
        raise NoPortDirectoryError if d.nil?
        d
      end
    end
  end
end

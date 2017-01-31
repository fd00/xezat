[![Build Status](https://travis-ci.org/fd00/xezat.svg?branch=master)](https://travis-ci.org/fd00/xezat)
[![Coverage Status](https://coveralls.io/repos/fd00/xezat/badge.svg?branch=master)](https://coveralls.io/r/fd00/xezat?branch=master)

# Xezat

Complement of cygport

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xezat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xezat

## Requirement

* Automake (subcommand `validate` uses `aclocal`)


## Usage

    xezat 0.0.4 -- Xezat is the complement of cygport

    Usage:

      xezat <subcommand> [options]

    Options:
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

    Subcommands:
      bump                  update CYGWIN-PATCHES/README
      create                create new cygport
      debug                 show cygport variables
      doctor                diagnose installed packages
      generate              generate additional files
      port                  copy cygport to git repository
      validate              validate package contents


### create

    xezat create -- create new cygport

    Usage:

      xezat create [options] cygport

    Options:
            -a, --app-only     application only
            -c, --category category  specify category
            -d, --description description  specify description
            -i, --inherit cygclass  inherit cygclasses
            -o, --overwrite    overwrite cygport
            -r, --repository repository  specify repository (github, google, sourceforge)
            -s, --summary summary  specify summary
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

Example.1

    % xezat create xezat-0.0.4-1bl1.cygport
    % cat xezat-0.0.4-1bl1.cygport

```bash
HOMEPAGE=""
SRC_URI=""

CATEGORY=""
SUMMARY=""
DESCRIPTION=""

PKG_NAMES="
  ${PN}
  lib${PN}0
  lib${PN}-devel
"
xezat_CONTENTS="
  usr/bin/*.exe
  usr/share
"
libxezat0_CONTENTS="
  usr/bin/*.dll
"
libxezat_devel_CONTENTS="
  usr/include
  usr/lib
"
xezat_SUMMARY="${SUMMARY} (licensing & readmes)"
libxezat0_SUMMARY="${SUMMARY} (runtime)"
libxezat_devel_SUMMARY="${SUMMARY} (development)"
```

Example.2 

    % xezat create -a -c Libs -i git --repository=github -s 'Complement of Cygport' -o xezat-0.0.4-1bl1.cygport
    % cat xezat-0.0.4-1bl1.cygport

```bash
HOMEPAGE="https://github.com/fd00/${PN}"
GIT_URI="https://github.com/fd00/${PN}.git"

CATEGORY="Libs"
SUMMARY="Complement of Cygport"
DESCRIPTION=""

inherit git
```

### debug

    xezat debug -- show cygport variables

    Usage:

      xezat debug cygport

    Options:
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

Example.1

    % xezat debug xezat-0.0.4-1bl1.cygport
    #<Xezat::VariableManager:0x000006011ba808
     @variables=
      {:AR=>"ar",
       :ARCH=>"x86_64",
       :ARCH_x86_64=>"1",
       :B=>"/usr/src/xezat-0.0.4-1bl1.x86_64/build",
       :BASH=>"/usr/bin/bash",
    (snip)
       :mirror_apache=>"http://www.apache.org/dist",
       :mirror_berlios=>"http://download.berlios.de http://download2.berlios.de",
       :mirror_cpan=>"http://search.cpan.org/CPAN",
       :mirror_cran=>"http://cran.r-project.org",
       :mirror_ctan=>"http://mirror.ctan.org/",
    (snip)
       :src_patchfile=>"xezat-0.0.4-1bl1.src.patch",
       :srcdir=>"/usr/src/xezat-0.0.4-1bl1.x86_64/src",
       :top=>"/usr/src",
       :workdir=>"/usr/src/xezat-0.0.4-1bl1.x86_64"}>
    %

### doctor

    xezat doctor -- diagnose installed packages

    Usage:

      xezat doctor

    Options:
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

Example.1

    % xezat doctor
    xezat doctor | Warn:   usr/include/attr/xattr.h is in multiple packages: [:"cygwin-devel", :"libattr-devel"]
    xezat doctor | Warn:   usr/share/man/man1/sha.1.gz is in multiple packages: [:openssl, :sha]
    xezat doctor | Warn:   usr/share/man/man3/Socket.3pm.gz is in multiple packages: [:"perl-Socket", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.Big5.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.GB2312.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.JISX0208.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.Korean.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.Pinyin.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.CJK.Stroke.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    xezat doctor | Warn:   usr/share/man/man3/Unicode.Collate.Locale.3pm.gz is in multiple packages: [:"perl-Unicode-Collate", :perl]
    %

### generate

    xezat generate -- generate additional files

    Usage:

      xezat generate [options] cygport

    Options:
            -o, --overwrite    overwrite file
            -p, --pkg-config   generate *.pc
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

Example.1

    % xezat generate xezat-0.0.4-1bl1.cygport -p
    % cat xezat-0.0.4-1bl1.x86_64/src/xezat-0.0.4/xezat.pc
    prefix=@prefix@
    exec_prefix=@exec_prefix@
    libdir=@libdir@
    includedir=@includedir@
     
    Name: xezat
    Description: Complement of cygport
    Version: @VERSION@
    Libs: -L${libdir} -lxezat
    Cflags: -I${includedir}
    %

### validate

    xezat validate -- validate package contents

    Usage:

      xezat validate [options] cygport

    Options:
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

### bump

    xezat bump -- update CYGWIN-PATCHES/README

    Usage:

      xezat bump cygport

    Options:
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

### port

    xezat port -- copy cygport to git repository

    Usage:

      xezat port cygport

    Options:
            -V, --verbose      print the results verbosely
            -n, --no-operation  print the results without actually copying any files
            -i, --inifile *.ini  specify inifile
            -t, --target portdir  specify git repository directory
            -h, --help         Show this message
            -v, --version      Print the name and version
            -t, --trace        Show the full backtrace when an error occurs

Example.1

    % cat ~/.xezat
    [xezat]
    distdir = /cygdrive/e/dist
    portdir = /cygdrive/e/yacp
    % xezat port xezat-0.0.4-1bl1.cygport
    % ls /cygdrive/e/yacp/xezat
    README xezat-0.0.4-1bl1.cygport xezat-0.0.4-1bl1.src.patch

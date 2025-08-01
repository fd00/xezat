# Xezat

[![Actions](https://github.com/fd00/xezat/actions/workflows/ruby.yml/badge.svg)](https://github.com/fd00/xezat/)
[![Gem Version](https://badge.fury.io/rb/xezat.svg)](https://badge.fury.io/rb/xezat)

Xezat is a helper tool for your daily packaging tasks with [Cygport](httpss://cygwin.com/cygport/).

## Features

Xezat provides the following subcommands through the `xezat` command:

*   `init`: Interactively generates a new `cygport` file.
*   `bump`: Bumps the package version and updates the `README` file.
*   `validate`: Validates that the `cygport` file and related files adhere to conventions.
*   `port`: Copies the `cygport` to a Git repository.
*   `announce`: Generates a template for ITP (Intent to Package) or `cygport` update announcements.
*   `doctor`: Checks your system for potential problems.
*   `generate`: Generates development files used by `cygport`.
*   `debug`: Assists in debugging `cygport` files.

You can check the details of each command with `xezat <command> --help`.

## Installation

Install the gem:

```bash
gem install xezat
```

## Usage

### 1. Creating a new package

```bash
xezat init foo.cygport
```

### 2. Bumping the version

```bash
xezat bump foo.cygport
```

### 3. Validating the package

```bash
xezat validate foo.cygport
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fd00/xezat](https://github.com/fd00/xezat).

This project utilizes Google Gemini for development assistance.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[script-package]: https://atom.io/packages/script
[mit]:          http://opensource.org/licenses/MIT
[author]:       http://github.com/perl6
[releases]:     https://github.com/perl6/atom-language-perl6/releases
[mit-badge]:    https://img.shields.io/apm/l/language-perl6.svg
[apm-pkg-link]: https://atom.io/packages/language-perl6
[apm-ver-link]: https://img.shields.io/apm/v/language-perl6.svg
[dl-badge]:     http://img.shields.io/apm/dm/language-perl6.svg
[contributing]: https://github.com/perl6/atom-language-perl6/blob/master/CONTRIBUTING.md
[CREDITS]: https://github.com/perl6/atom-language-perl6/blob/master/CREDITS
[build-status]: https://travis-ci.org/perl6/atom-language-perl6.svg?branch=master
[build-status-link]: https://travis-ci.org/perl6/atom-language-perl6
[issues]: https://github.com/perl6/atom-language-perl6/issues
[travis-badge]: https://travis-ci.org/perl6/atom-language-perl6.svg?branch=master
[travis-link]: https://travis-ci.org/perl6/atom-language-perl6?branch=master
[fira-code]: https://github.com/tonsky/FiraCode
[screenshot-1]: https://raw.githubusercontent.com/perl6/atom-language-perl6/master/images/example1.png

# Atom Perl 6 Support - »ö« Official Edition!

[![apm package][apm-ver-link]][apm-pkg-link]
[![][dl-badge]][apm-pkg-link]
[![][mit-badge]][mit]
[![travis][travis-badge]][travis-link]

A colorful, thoughtful, and helpful language grammar for Perl 6! See
[here](#how-do-i-use-this) for questions about usage.

![A screenshot of an funnified Perl 6 file][screenshot-1]

## Integration
This package has integration with the Atom [script][script-package] package.
With both this package and the `script` package you can execute
highlighted Perl 6 code or the whole document, even if it hasn't been saved using
a keyboard shortcut.

## What Makes This The *Fun* Edition?

> Perl 6 is optimized for fun. ― Audrey Tang

* This package was designed to work with [Fira Code][fira-code] ligatures

* Much more syntax highlighted (numbers, operators, interpolation, traits, better strings).

* Some day we hope this package will also contain support for many popular
  atom packages that have service hooks like autocomplete+ and linter


## See something? Say something!
See something highlighted incorrectly? See something LTA (Less Than Awesome)?
Please report it on the [issue tracker][issues]. Any issue no matter how small
should be reported. It is our hope that this is not only the best Perl 6
highlighter for Atom, but the best highlighter for Atom out there.

## Contributing
Contributions are welcome! Please see [`CONTRIBUTING.md`][contributing] for a tutorial on writing Atom syntax grammars and more information!

## Potential Future Features
Integration with Autocomplete+, linter or other packages are possible future features. See [Contributing](#contributing) if you want to help!

## How do I use this?

This language grammar should automatically highlight `.p6`, `.pod6`, `.pm6` and
`.nqp` files. The language grammar will also detect files whose first
line includes `use v6`, a shebang whose last term before any whitespace is
`perl6` , `=begin pod`, or `my class`.

If you are having issues, the `language-perl` package is probably taking
precedence. To remedy this you can:

* Click the language name in the status-bar (`Ctrl+Shift+L`) and select `Perl 6 FE`
* If you want to permanently change the preferences for a file type,
  add the following to your `config.cson` (*Edit* → *Config*):

  ```coffee
  "*":
    core:
      customFileTypes:
        'source.perl6fe': [
          'p6'
          'pm6'
          # Add pm and t if you want auto choose this highlighter for .pm or 't
          # files.
          'pm'
          't'
        ]
  ```

Please be aware that if you do not include the `t` extension
above, your `t` files will be highlighted with the `language-perl` highlighter unless the first line contains `use v6;`.

# License

[MIT][mit] © All [contributors][CREDITS]
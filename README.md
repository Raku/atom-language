# Atom Perl 6 Support - »ö« (Fun) Edition!

[![apm package][apm-ver-link]][releases]
[![][dl-badge]][apm-pkg-link]
[![][mit-badge]][mit]
[![travis][travis-badge]][travis-link]

A colorful, thoughtful, and helpful language grammar for Perl 6! See [here](#how-do-i-use-this) for questions about usage.

![A screenshot of an funnified Perl 6 file][screenshot-1]

# Integration
It has integration with the Atom [script][script-package] package. With this package and the plugin you can execute
highlighted Perl 6 code or the whole document even if it hasn't been saved with
a keyboard shortcut.

## What Makes This The Fun Edition™?

> Perl 6 is optimized for fun ― Audrey Tang

* This package was developed to work with [Fira Code][fira-code] ligatures

* More syntax highlighted (numbers, operators, interpolation, traits, better strings).

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
Autocomplete+, linter, atom-build.

## How do I use this?

It should automatically highlight `p6`, `pod6`, `pm6` and `nqp` files.
It should also highlight files whose first line includes `use v6;`.
If this doesn't work you can:

* Click the language name in the status-bar (`Ctrl+Shift+L`) and select `Perl 6 FE`
  * If you want to permanently change the preferences for a file type,
    add this to your `config.cson` (*Application: Open Your Config*):

  ```coffee
  '*':
    core:
      customFileTypes:
        'source.perl6': [
          # Any extensions you'd like to override
          'p6'
          'pm6'
          't'
        ]
  ```

> Please be aware that if you do not include the `t` extension
above, your `t` files will be highlighted with the `language-perl` highlighter
(using either P5 or P6 grammar depending on if you have the `use v6;` pragma).

# License

[MIT][mit] © All [contributors][CREDITS]
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

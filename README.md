# Atom Perl 6 Support - Funner Edition!

[![apm package][apm-ver-link]][releases]
[![][dl-badge]][apm-pkg-link]
[![][mit-badge]][mit]

A more colorful, thoughtful, and helpful language grammar for Perl 6. Derived from the builtin [language-perl](https://github.com/atom/language-perl) package but with many bugfixes and additions.

![A screenshot of an funnified Perl 6 file](https://raw.githubusercontent.com/perl6/atom-language-perl6/master/images/example3.png)

## How do I use this?

It should automatically highlight `p6`, `pod6`, `pm6` and `nqp` files.
It should also highlight files whose first line includes `use v6;`.
If this doesn't work you can:

1. Click the language name in the status-bar (`Ctrl+Shift+L`) and select `Perl 6 FE`
2. Add this to your `config.cson` (*Application: Open Your Config*):

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
above, your `t` files will be highlighted with the `language-perl` highlighter (using either P5 or P6 grammar depending on if you have the `use v6;` pragma).

## What Makes This The Fun Edition™?

> Perl 6 is *optimized for fun* -Audrey Tang

* This package was developed to work with [Fira Code](https://github.com/tonsky/FiraCode) ligatures

* More syntax highlighted (numbers, operators, interpolation, traits, better strings)

* This package will also soon contain support for many popular atom packages that have service hooks like autocomplete+ and linter

Here's a few more examples:

![Another screenshot of a funnified Perl 6 file](https://raw.githubusercontent.com/perl6/atom-language-perl6/master/images/example1.png)

![Yet another screenshot of a funnified Perl 6 file](https://raw.githubusercontent.com/perl6/atom-language-perl6/master/images/example2.png)

# Contributing

Contributions are welcome! Please see [`CONTRIBUTING.md`](/CONTRIBUTING.md) for info!

# Potential future features?
Autocomplete+, linter, atom-build, and atom-runner.  Maybe even integrating a perl6 REPL would be fun!

# License

[MIT][mit] © All [contributors](/CREDITS)


[mit]:          http://opensource.org/licenses/MIT
[author]:       http://github.com/perl6
[releases]:     https://github.com/perl6/atom-language-perl6/releases
[mit-badge]:    https://img.shields.io/apm/l/language-perl6.svg
[apm-pkg-link]: https://atom.io/packages/language-perl6
[apm-ver-link]: https://img.shields.io/apm/v/language-perl6.svg
[dl-badge]:     http://img.shields.io/apm/dm/language-perl6.svg
[slack-badge]:  http://perl6.bestforever.com/badge.svg
[slack]:        http://perl6.bestforever.com
[contributing]: (/CONTRIBUTING.md)

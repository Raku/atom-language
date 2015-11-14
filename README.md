# Perl 6 Language Support Fun Edition!

[![apm package][apm-ver-link]][releases]
[![][dl-badge]][apm-pkg-link]
[![][mit-badge]][mit]

A more colorful, thoughtful, and helpful language grammar for Perl 6. Derived from the builtin [language-perl](https://github.com/atom/language-perl) package but with many bugfixes and additions.  You might ask why I didn't just add a PR there but I feel that this package adds quite a bit more that it might not be everyone's cup of tea. However, I do plan on adding support for autocomplete+, linter, atom-build, and atom-runner.  Maybe even integrating a perl6 REPL would be fun!

![A screenshot of an funnified Perl 6 file](https://raw.githubusercontent.com/MadcapJake/language-perl6fe/master/example.png)

## What's Makes This The Fun Edition™?

> Perl 6 is *optimized for fun* -Audrey Tang

This package was developed to work with Fira Code ligatures:

![Example of ligatures]()

The color palette is quite a bit more varied than the baseline perl highlighter and maybe even moreso than the vim-perl plugin:

![Example of varied highlighting]()

This package will also soon contain support for many popular atom packages that have service hooks like autocomplete+:

![Example of autocomplete+]()

Or even a linter using `perl6 -c`:

![Example of builtin atom linter]()

We also (will hopefully) have a builtin REPL:

![Example of Perl6 REPL]()

# License

[MIT][mit] © [Jake Russo][author] et [al][contributors]


[mit]:          http://opensource.org/licenses/MIT
[author]:       http://github.com/MadcapJake
[contributors]: https://github.com/MadcapJake/language-perl6fe/graphs/contributors
[releases]:     https://github.com/MadcapJake/language-perl6fe/releases
[mit-badge]:    https://img.shields.io/apm/l/language-perl6fe.svg
[apm-pkg-link]: https://atom.io/packages/language-perl6fe
[apm-ver-link]: https://img.shields.io/apm/v/language-perl6fe.svg
[dl-badge]:     http://img.shields.io/apm/dm/language-perl6fe.svg

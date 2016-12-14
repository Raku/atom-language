# Contributing:

### Installing for Development
First uninstall the package from Atom. Then clone the Github repository into whichever folder you want.

Now run `apm link atom-language-perl6` and it will install and link to the folder you just cloned. Now you are ready to start hacking away!

### Helpful tips:

#### Atom Grammars

* Atom uses a TextMate type grammar. While TextMate uses plist's(XMLish),
  Atom stores them in [CSON][CSON] format.
* In CSON the only characters that need to be escaped inside a single quoted
  string are single quotes(`'`), backslashes(`\`) and control codes.

### Oniguruma Regex Engine
* If you want use a hex codepoint instead of typing the symbol in, please use `\\x{20}` (Unescaped form: `\x{20}`).
  This will use the Regex engine for this instead of using the JSON/CSON method
  of noting unicode codepoints (e.g. `\u20` which can be used in CSON/JSON).
* Specify Unicode propertys like this: `\\p{Alpha}`(`\p{Alpha}` in unescaped form). See the cheatsheet linked below for all the ones that are guarenteed to work.

* Atom uses the [Oniguruma][Oniguruma] Regex engine which is the same one that Ruby uses.
* See the [Regex reference/cheatsheet][Oniguruma-RE] for Oniguruma.

* A helpful site to try out Ruby regex is [Rubular][Rubular], although it only assumes `/…/` regex syntax so you must escape forward slashes. You do not need to escape forward slashes in the CSON file.
*
* [Regex101](regex101.com) is more graphical and nicer but make
  sure to test out the regex on [Rubular][Rubular] once you have it assembled!

# Extended info:

* The code that Atom uses to actually process the grammars is called
  [first-mate][first-mate].


# The issue tracker and you
For the purposes of this project, a *bug* is anything which alters the
highlighting of surrounding text. An *improvement* is anything else. Because
of this, a priority system seems the best way to categorize any issues.

* `priority:high` is reserved for bugs which ruin highlighting for potentially
  a large number of lines below.
* `priority:medium` is for medium bugs that may after a small amount of surrounding
  text or missing features/improvements that are glaring flaws.
* `priority:low` is for either small bugs that don't ruin the highlighting of
  any surrounding text or reasonable improvements.



[CSON]: https://github.com/bevry/cson
[Rubular]: http://rubular.com/
[Oniguruma]: https://en.wikipedia.org/wiki/Oniguruma
[Oniguruma-RE]: https://github.com/kkos/oniguruma/blob/master/doc/RE
[first-mate]: https://github.com/atom/first-mate

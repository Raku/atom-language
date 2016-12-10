# Contributing:

# Helpful tips:

* Atom uses a TextMate type grammar. While TextMate uses plist's(XMLish),
  Atom stores them in [CSON][CSON] format.
* In CSON the only characters that need to be escaped inside a single quoted
  string are single quotes(`'`), backslashes(`\`) and control codes.
* If you want use a hex codepoint instead of typing the symbol in, for example,
  if it's a range in a character class, please use `\\x{20}`(`\x{20}` in its unescaped form).
  This will use the Regex engine for this instead of using the JSON/CSON method
  of noting unicode codepoints ( Ex: `\u20` which does a CSON/JSON).

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



[CSON]: (https://github.com/bevry/cson)
[Rubular]: (http://rubular.com/)
[Oniguruma]: (https://en.wikipedia.org/wiki/Oniguruma)
[Oniguruma-RE]: (https://github.com/kkos/oniguruma/blob/master/doc/RE)
[first-mate]: https://github.com/atom/first-mate

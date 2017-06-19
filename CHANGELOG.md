# v1.16.0
* We now automate m// and s/// grammar generation using different delimiters.
  Now `m/ /`, `s/ / /`, `S/ / /`, `rx/ /` regex should work for more delimiters, and existing delimiters
  that already worked should have less issues. Some of these delimiters
  I did not know worked until now!
* `m[ ]`, `m⟅ ⟆`, `m{ }`
* `m< >`, `m ( )`, `m“ ”`
* `m„ ”`, `m‘ ’`, `m‚ ’`
* `m｢ ｣`, `m｢ ｣`, `m« »`
* Also a reminder than arbitrary delimiters in regex still work as well: `'test' ~~ m* test *`
* Fix highlighting of `.match` when not using parens (`.match: / regex /`
* Highlight all of the `MONKEYS` (i.e. `MONKEY-TYPING` and friends)

# v1.15.1
* Improve support for bare regex after `when` or `~~` and other special words/symbols. List:
  * `~~`
  * `when`
  * `=>`
  * `[`
  * `(`
  * `=`

# v1.15.0
* Fix issue with `s:{ }`, substitution regex using brackets as delimiters. Fixes Issue #60
* Add support for some low-9 quotation styles ‚ single-low 9 quotation mark ― left single quotation mark ‘
* Fix highlighting of bracket before number. Fixes Issue #58

# v1.14.3
* Fix a bug in highlighting of := binding operator
* Fix ligature of `==>` operator when using Fira Code
* Some fixes for single quotes inside of regex. Fixes Issue #53 and #44

# v1.14.2
* Highlight ^-10 the same as ^10
* Fix highlighting of regex using { } delimiters. Fixes Issue #52

# v1.14.1
* Highlight QAST as we highlight nqp
* Add a bunch of methods, mostly Iterator methods
 * pull-one, push-exactly, push-at-least, push-all, push-until-lazy
    , sink-all, skip-at-least, skip-at-least-pull-one
* Fix highlighting of `1…10` when using the ellipsis

# v1.14.0
* Sort of fix variable highlighting in qq quoted heredocs. Still has some issues
  though.
* Highlight `is-lazy`, `trim-trailing` and `trim-leading` methods
* Highlight `Order` types (More|Less|Same)
* Highlight `is pure` trait
* Highlight `quietly` and `:exists`
* Enable quoting using
  `„Low-double quotation mark ― Left/Right double quotation mark quoting.“`
  Fixes Issue #48

# v1.13.8
* Fix highlighting of `proto method X`, `proto sub X` etc. Fixes Issue #31

# v1.13.7
* Add highlighting for `.keep` method.
* Fix `.break` highlighting as a flowcontrol keyword when used as method.
  Fixes Issue #33
* Fix two variables in a row not allowing hyphens in variable name.
  Fixes Issue #40

# v1.13.6
* Fix scientific notation with negative exponents not rendering as numbers.
  Fixes Issue #35
* Fix variable names not in interpolated strings not highlighting properly when
  certain non-ASCII characters were used. Fixes Issue #36

# v1.13.5
* Fix angle bracket word quoting starting improperly. Fixes Issue #39
* Fix array word quoting not end if `\` was at the end. Fixes Issue #38

# v1.13.4
* Fix README.md's instructions on how to override the built in Perl highlighter.
  The previous instructions were not accurate and did not properly work.
* Add quoting/commenting using the S-shaped bag delimiter `⟅ ⟆`.
* Add highlighting for `mkdir` routine/method.

# v1.13.3
* Allow angle bracket multi-line quoting directly after the `for` keyword. Fixes Issue #37

# v1.13.2
* Add support for the assignment operator `:=`
* Highlight the `throws` method/routine

# v1.13.1
* Add `ords` routine and method. `[fb6d26b]`
* Fix highlighting breaking when using `/` with another `/` on the line. `[a91eeef]`
  Fixes Issue #34
* add q/qq/Q:nfkc and q/qq/Q:nfkd quoting. It is not yet implemented in Rakudo
  but it is in roast (NFK-types.t). `[02db872][26aecbe]`
* Tag `TOP` in grammars differently for docs.perl6.org. `[e6c8c77]`

# v1.13.0
* Interpolated heredocs now highlight variables and other interpolated things. Fixes Issue #27
* Fixed signed numbers like `+.2` without a whole number from highlighting. Fixes Issue #29
* Make sure the `==>` operator highlights properly.

# v1.12.0
* Fix a problem with `multi sub` not highlighting the sub's name properly. Fixes Issue #26
* Make sure that q/qq/Q quoting works when there is a bracket before the q/qq/Q and no space.
* Regular expressions using `m` or `rx` now allow arbitrary delimiters.

# v1.11.4
* Add preliminary support for `s///` and `S///`.

# v1.11.3
* Fix a problem where a capture marker inside regex was recognized as a grouping
  parenthesis, and could overrun the regex if there was another paren on the same
  line. Fixes Issue #24

# v1.11.2
* Fix Issue #21:
  * Fix − (U+2212 minus) and + in front of numbers or hex numbers.
  * Fix hex numbers not highlighting when at start of line.
  * Fix hex numbers not highlighting when hyphen was in front of it.
* Fix highlighting breaking when the word `regex` was used as a routine name.
  Fixes Issue #17

# v1.11.1
* Fix problem where the recently added feature so routines and methods can
  highlight inside interpolated strings would cause it to overrun the length of
  the string if there were parenthesis later on in the line. Fixes Issue #20

# v1.11.0

## Pod
* Highlight `X< >` tags. Fixes Issue #17
* Add support for `C<< >>`, `C<<< >>>` and `C« »` delimiters for all types of tags.
  Fixes Issue #18
* Nested tags now highlight.
* Tags can now span multiple lines. Fixes Issue #14

## Misc
* Fix q/qq/Q quoting not highlighting when surrounded by brackets.
* Highlight `<<< >>>` delimiters for q/qq/Q quoting.
* Highlight `« »` delimiters for q/qq/Q quoting.
* Add ```#`«``` and ```#`<<<``` delimiters for multiline comments.

# v1.10.0
* Method calls and routine calls in interpolated strings now highlight.
  Example: `"$var.method()"` Fixes Issue #13
* Angle bracket word quoting across multiple lines works again. It will
  only allow multi-line quoting this way if the opening angle bracket is after
  an `=` sign.
* Allow non-word characters like `-` and `'` to be in `token`, `rule` and `regex`
  names for grammars.
* Highlight `:sym< >` for protoregex action `method`'s. Fixes Issue #12
* Highlight pod =head sections as headings not comments when they continue onto
  the next line. Fixes Issue #16
* Make sure fonts with ligatures like Fira Code don't use ligatures in comments,
  or quoted strings.

# v1.9.11
* Highlight unicode hex codes in regex character classes. Fixes Issue #10
* Highlight regex named capture variables in quoted strings. Fixes Issue #9
* Fix a bug that could cause angle bracket word quoting to be triggered by
  the less-than operator (`<`).
* Add `.so` and `.not` methods.

# v1.9.10
* Fix link on the readme

# v1.9.9
* Keys of pairs now highlight properly if no spaces used for unquoted keys.
  Fixes Issue #4
* Fix angle bracket delimited word array's not highlighting properly with a `}`
  immidiately before the closing angle bracket. Fixes Issue #2
* Detect files that have `=comment` as the first line as Perl 6. You will
  probably need to disable Atom's built in Perl Grammar to get this to work
  though…

# v1.9.8
* Fix highlighting of fully qualified method names. Fixes #8

# v1.9.6
* Fix highlighting of private methods. Example: `method !priv-method`. Issue #7
* Fix `q[]` quoting constructs not quoting when there were surounded by
  parentheses.

# v1.9.5
* Detect files that have `use v6;`, `=begin pod` or `my class` as the first line
  as Perl 6. You will probably need to disable Atom's built in Perl Grammar to
  get this to work though...
* Get integration with the script package working. See the README for details.

# v1.9.1

### Methods/Functions
* Add `get`, `new-from-pairs` and `words` methods and functions.
### Other
* Add get, words, new-from-pairs to methods/functions
* Make sure bareword keys don't highlight in pairs

# The below issue numbers are for https://github.com/MadcapJake/language-perl6fe

# v1.9

### Regex
* Let regex using `m/ /` or `rx/ /` appear anywhere and span multiple lines.
* Fancy single quotes in regex now actually quote `/‘…’/`. They can also be
  nested. Fixes issue #45
* Let bare regex `/ /` appear after `=>`. Mostly fixes issue #35

### Heredocs
* Fix fancy heredoc delimiters like `q:to/📝🔚/`; Fixes issue #36

## Quoting
* Get left single and right single quotation marks working with nesting
  `‘testing 1 ‘2’ 3’`
* Get left double and right double quotation marks working with nesting
  `“testing 1 “2” 3”`
* Get left single and right single quotation marks working inside regex.
  Fixes issue #48
* Have the `｢this｣` quoting construct (which is a shortcut for `Q[]` quoting)
  work.
* Get halfwidth (standard) width corner brackets working for these strings:
  `｢nesting｢works｣｣`.
* Array indices in interpolated strings/quoting now highlight correctly. #24

### `Q`, `qq` and `q` quoting constructs
* `Q`, `qq` and `q` constructs using `(( ))`, `{{ }}`, `<< >>`, `[ ]`, `[[ ]]`,
  `( )`, `{ }`, `/ /`,  `< >` now properly escape delimiters and other escape
  sequences. Fixes issue #46
* Get `Q`, `qq` and `q` constructs using arbitrary non-word characters working.
  Example: q%…%
* Add `Q`, `qq` and `q` constructs using `‘…’` and  `“…”`. Example: q“…”
* Add `Q`, `qq` and `q` constructs using `｢…｣`, `(((…)))`, `{{{…}}}`, `[[[…]]]`
  and`「…」`.


### Variables
* Fix certain `$<variables>` inside interpolated strings not syntax
  highlighting. Fixes issue #41
* Make `:token` `:regex` `:rule` not explode the highlighter. Fixes issue #33
* ￼Get all the forms of qq[] properly highlighting variables (interpolation).
  Fixes issue #18

### Methods
* Highlight `.categorize`, `.prepend`, `.parse-base`, `categorize-list` and
  `.antipairs` methods. Fixes issue #38
* Add `IO` related methods.
* Make sure some more things highlight properly if used as keys for pairs.
* Add `long`, `longlong`, `Pointer` and `CArray` data types
* Make sure `/` As a metaoperator `[/]` doesn't break syntax highlighting
  Fixes #34

### Comments
* Get all types of ```#`(``` Multiline comments working when there is leading
  whitespace before the #\`( Fixes issue #44
* Get these multiline comments working:
  ```#`((( )))```, ```#`{{{ }}}```, ```#`[[[ ]]]```, ```#`<< >>```, ```#`< >```,
  ```#`“ ”```, ```#`‘ ’```

### Pod
* Pod comments now highlight properly working when there is leading whitespace.
* Make sure pod after `=para` and `=for` immediately stop that block. Make
  sure formatting doesn't run on further. Fixes issue #51
* Make sure pod after all other abbreviated forms like `=head` highlight as
  comments as well. Fixes issue #50

## v1.8
#### Quoting:
* Left double quote Right double quote ```“…”```
* Right double quote Right double quote ```”…”```
* Left single quote Right single quote ```‘…’```

#### Qx and qx:
* `qx[]` and `Qx[]` used to syntax highlight variables. Now they highlight
  like `Q[]` and `q[]`
* `Q|w|ww|v|s|a|h|f|c|b|p` now highlight properly. Fixes issue #40
### Multi line comments:
* Get these working:  ```#`{{``` and ```#`((``` and ```#`｢```

### Other
* Highlight `return-rw`

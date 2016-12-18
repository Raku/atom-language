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

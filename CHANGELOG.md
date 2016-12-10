# v1.10

### Methods/Functions
* Add `get`, `new-from-pairs` and `words` methods and functions.
### Other
* Add get, words, new-from-pairs to methods/functions
* Make sure bareword keys don't highlight in pairs


# v1.9

### Regex
* Let regex using `m/ /` or `rx/ /` appear anywhere and span multiple lines.
* Fancy single quotes in regex now actually quote `/‘…’/`. They can also be nested. Fixes issue #45
* Let bare regex `/ /` appear after `=>`. Mostly fixes issue #35

### Heredocs
* Fix fancy heredoc delimiters like `q:to/📝🔚/`; Fixes issue #36

## Quoting
* Get left single and right single quotation marks working with nesting `‘testing 1 ‘2’ 3’`
* Get left double and right double quotation marks working with nesting `“testing 1 “2” 3”`
* Get left single and right single quotation marks working inside regex. Fixes issue #48
* Have the `｢this｣` quoting construct (which is a shortcut for `Q[]` quoting) work.
* Get halfwidth (standard) width corner brackets working for these strings: `｢nesting｢works｣｣`.
* Array indices in interpolated strings/quoting now highlight correctly. #24

### `Q`, `qq` and `q` quoting constructs
* `Q`, `qq` and `q` constructs using `(( ))`, `{{ }}`, `<< >>`, `[ ]`, `[[ ]]`, `( )`,
`{ }`, `/ /`,  `< >` now properly escape delimiters and other escape sequences. Fixes issue #46
* Get `Q`, `qq` and `q` constructs using arbitrary non-word characters working. Example: q%…%
* Add `Q`, `qq` and `q` constructs using `‘…’` and  `“…”`. Example: q“…”
* Add `Q`, `qq` and `q` constructs using `｢…｣`, `(((…)))`, `{{{…}}}`, `[[[…]]]` and`「…」`.


### Variables
* Fix certain `$<variables>` inside interpolated strings not syntax highlighting. Fixes issue #41
* Make `:token` `:regex` `:rule` not explode the highlighter. Fixes issue #33
* ￼Get all the forms of qq[] properly highlighting variables (interpolation). Fixes issue #18

### Methods
* Highlight `.categorize`, `.prepend`, `.parse-base`, `categorize-list` and `.antipairs` methods. Fixes issue #38
* Add `IO` related methods.
* Make sure some more things highlight properly if used as keys for pairs.
* Add `long`, `longlong`, `Pointer` and `CArray` data types
* Make sure `/` As a metaoperator `[/]` doesn't break syntax highlighting Fixes #34

### Comments
* Get all types of ```#`(``` Multiline comments working when there is leading whitespace before the #\`( Fixes issue #44
* Get these multiline comments working:
  ```#`((( )))```, ```#`{{{ }}}```, ```#`[[[ ]]]```, ```#`<< >>```, ```#`< >```, ```#`“ ”```, ```#`‘ ’```

### Pod
* Pod comments now highlight properly working when there is leading whitespace.
* Make sure pod after `=para` and `=for` immediately stop that block. Make sure formatting doesn't run on further. Fixes issue #51
* Make sure pod after all other abbreviated forms like `=head` highlight as comments as well. Fixes issue #50


## v1.8
#### Quoting:
* Left double quote Right double quote ```“…”```
* Right double quote Right double quote ```”…”```
* Left single quote Right single quote ```‘…’```

#### Qx and qx:
* `qx[]` and `Qx[]` used to syntax highlight variables. Now they highlight like `Q[]` and `q[]`
* `Q|w|ww|v|s|a|h|f|c|b|p` now highlight properly. Fixes issue #40
### Multi line comments:
* Get these working:  ```#`{{``` and ```#`((``` and ```#`｢```

### Other
* Highlight `return-rw`

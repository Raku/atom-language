## v1.9
* Regex using let regex using `m/ /` or `rx/ /` appear anywhere and span multiple lines.
* Get halfwidth (standard) width corner brackets working for these strings: `｢nesting｢works｣｣`.
* Fix fancy heredoc delimiters like `q:to/📝🔚/`; Fixes Issue #36
* Get left single and right single quotation marks work with nesting `‘testing 1 ‘2’ 3’`
* Get left double and right double quotation marks work with nesting `“testing 1 “2” 3”`
* Have the `｢this｣` quoting construct (which is a shortcut for `Q[]` quoting) work.
* Fix certain `$<variables>` inside interpolated strings not syntax highlighting. Fixes Issue #41
* Make `:token` `:regex` `:rule` not explode the highlighter. Fixes Issue #33
* ￼Get all the forms of qq[] properly highlighting variables (interpolation). Fixes Issue #18
* Qw Quoting construct not recognized. Highlighted wrong and ruins highlighting when using " inside it. Fixes Issue #40
* Get all types of #\`( Multiline comments working when there is leading whitespace before the #\`( Fixes Issue #44
* Get these multiline comments #\`((( #\`{{{ and #\`[[[ working
* Get multiline comments with whitespace between ```#``` and the brackets working. Example: ```#`  (```
* Highlight `.categorize`, `.prepend`, `.parse-base`, `categorize-list` and `.antipairs` methods. Fixes Issue #38
* Add `long`, `longlong`, `Pointer` and `CArray` data types
* Make sure `/` As a metaoperator `[/]` doesn't break syntax highlighting Fixes #34

## v1.8
#### Quoting:
* Left double quote Right double quote ```“…”```
* Right double quote Right double quote ```”…”```
* Left single quote Right single quote ```‘…’```

#### Qx and qx:
* `qx[]` and `Qx[]` used to syntax highlight variables. Now they highlight like `Q[]` and `q[]`
* `Q|w|ww|v|s|a|h|f|c|b|p` now highlight properly. Fixes Issue #40
### Multi line comments:
* Get these working:  ```#`{{``` and ```#`((``` and ```#`｢```

### Other
* Highlight `return-rw`

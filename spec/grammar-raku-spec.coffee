## Please note if you put hash symbols in any of the `it´ lines it will
## skip the test. This can be useful, but for refering to Issue numbers
## please use the № symbol in place of a hash if the test passes, and
## a hash if it currently fails.

## Keep ALL lines at _exactly_ 80 characters or _less_ or Travis CI's Linter
## will cause the build to fail. Maybe there's a way around this…

describe "Raku grammar", ->
  grammar = null
  grammarRE = null
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl6")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.raku")
      grammarRE = atom.grammars.grammarForScopeName("source.regexp.raku")

  ## Sanity checks
  it "parses source.raku", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.raku"

  it "parses source.regexp.raku", ->
    expect(grammarRE).toBeDefined()
    expect(grammarRE.scopeName).toBe "source.regexp.raku"

  ## First line language detection
  it "use v6 works", ->
    lne = " use v6;"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()
  it "First line: =comment detected as Raku", ->
    lne = " =comment detected as Raku"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()
  it " =begin pod works", ->
    lne = " =begin pod"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()

  # Types
  it "Same highlights as a type", ->
    {tokens} = grammar.tokenizeLine 'Same'
    expect(tokens[0]).toEqual value: 'Same',
    scopes: [ 'source.raku', 'support.type.raku' ]

 ## Bugs
# $line.match(/^\s*$/)
  it "s:g[] with adverbs highlight properly №69", ->
    {tokens} = grammar.tokenizeLine "s:g[^testing$] ^"
    expect(tokens[3]).toEqual value: '^',
    scopes: [ 'source.raku', 'string.regexp.bracket.raku',
    'entity.name.section.boundary.regexp.raku' ]
    expect(tokens[7]).toEqual value: ' ', scopes: [ 'source.raku' ]

  it "identifiers with embedded dash/apostroph highlight properly № 83", ->
    {tokens} = grammar.tokenizeLine "$var-var-123 \"@var\'var-123\""
    expect(tokens[1]).toEqual value: 'var-var',
    scopes: [ 'source.raku','meta.variable.container.raku',
    'variable.other.identifier.raku' ]
    expect(tokens[5]).toEqual value: "var\'var",
    scopes: [ 'source.raku', 'string.quoted.double.raku',
    'variable.other.identifier.interpolated.raku' ]

  it "when before bare regex highlights properly", ->
    {tokens} = grammar.tokenizeLine "when / ^ /"
    expect(tokens[2]).toEqual value: '/', scopes: [
      'source.raku', 'punctuation.definition.regexp.raku' ]

  it "bracket regex with s: highlights properly № 60", ->
    {tokens} = grammar.tokenizeLine "s:g { [^ | <?after '\\\\'>] <!before '..\\\\'> <-[\\\\]>+ '\\\\..' ['\\\\' | $ ] } = '' { };"
    expect(tokens[1]).toEqual value: ':g',
    scopes: [ 'source.raku', 'entity.name.section.adverb.regexp.raku' ]
    expect(tokens[3]).toEqual value: '{',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.raku' ]
    expect(tokens[5]).toEqual value: '^',
    scopes: [ 'source.raku', 'fstring.regexp.raku',
    'entity.name.section.boundary.regexp.raku' ]

  it "bracket before number does not accidently highlight as a number № 58", ->
    {tokens} = grammar.tokenizeLine "{1}"
    expect(tokens[1]).toEqual value: '1',
    scopes: [ 'source.raku', 'meta.block.raku',
    'constant.numeric.raku' ]

  it ":= assignment highlights as one token and correctly", ->
    {tokens} = grammar.tokenizeLine "10 := 11"
    expect(tokens[2]).toEqual value: ':=',
    scopes: [ 'source.raku', 'storage.modifier.assignment.raku' ]

  it "single quotes in regex don't break", ->
    {tokens} = grammar.tokenizeLine "/ '/' /"
    expect(tokens[0]).toEqual value: '/',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.raku' ]
    expect(tokens[2]).toEqual value: "'",
    scopes: [ 'source.raku', 'string.regexp.raku',
    'string.literal.raku' ]
    expect(tokens[5]).toEqual value: ' /',
    scopes: [ 'source.raku', 'string.quoted.single.single.raku' ]

  it "m:i{blah} highlights as regex", ->
    {tokens} = grammar.tokenizeLine "m:i{ blah }"
    expect(tokens[2]).toEqual value: '{',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.raku' ]

  it "^-10 highlights as a number", ->
    {tokens} = grammar.tokenizeLine "^-10"
    expect(tokens[0]).toEqual value: '^-10',
    scopes: [ 'source.raku', 'constant.numeric.raku' ]

  it "Regex using .match highlights $line.match(/^\\s*$/)", ->
    {tokens} = grammar.tokenizeLine '$line.match(/^\\s*$/)'
    expect(tokens[3]).toEqual value: 'match',
    scopes: [ 'source.raku', 'support.function.raku' ]
    expect(tokens[5]).toEqual value: '/',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.raku' ]

  it "Bare Regex with ~~ before it highlights", ->
    {tokens} = grammar.tokenizeLine '"t" ~~ /^\\s$/'
    expect(tokens[6]).toEqual value: '/',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.raku' ]

  it "proto method does not highlight properly. Issue № 31", ->
    {tokens} = grammar.tokenizeLine 'proto method rename(|) { * }'
    expect(tokens[0]).toEqual value: 'proto',
    scopes: [ 'source.raku', 'storage.type.declarator.multi.raku' ]
    expect(tokens[2]).toEqual value: 'method',
    scopes: [ 'source.raku', 'storage.type.declarator.type.raku' ]
    expect(tokens[4]).toEqual value: 'rename',
    scopes: [ 'source.raku', 'entity.name.function.raku' ]

  it "Putting spaces around / division operator highlights properly. Issue № 34", ->
    {tokens} = grammar.tokenizeLine 'isa-ok(1 / 4, Rat, "/ makes a Rat");'
    expect(tokens[4]).toEqual value: '/',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]

  it "Two variables in a row don't allow hyphens in variable name. Issue № 40", ->
    {tokens} = grammar.tokenizeLine '$reverse-solidus$reverse-solidus'
    expect(tokens[3]).toEqual value: 'reverse-solidus',
    scopes: [
      'source.raku', 'meta.variable.container.raku',
      'variable.other.identifier.raku'
    ]

  it "Keywords that are flow control highlight as methods when used as methods. Issue № 35", ->
    {tokens} = grammar.tokenizeLine '$p2.break'
    expect(tokens[3]).toEqual value: 'break',
    scopes: [ 'source.raku', 'support.function.raku' ]

  it "1e-6 highlights as a number. Issue № 35", ->
    {tokens} = grammar.tokenizeLine '1e-6'
    expect(tokens[0]).toEqual value: '1e-6',
    scopes: [ 'source.raku', 'constant.numeric.raku' ]

  it "Issue № 36. Variables highlight correctly if they contain any non-ASCII characters ", ->
    {tokens} = grammar.tokenizeLine '$ΔxAB'
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.raku', 'meta.variable.container.raku',
      'variable.other.identifier.sigil.raku'
    ]
    expect(tokens[1]).toEqual value: 'ΔxAB',
    scopes: [
      'source.raku', 'meta.variable.container.raku',
      'variable.other.identifier.raku'
    ]

  it "Issue № 39. Angle bracket quoting needlessly starts", ->
    {tokens} = grammar.tokenizeLine '$i++ < 3; # >'
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.raku',
      'meta.variable.container.raku',
      'variable.other.identifier.sigil.raku'
    ]
    expect(tokens[1]).toEqual value: 'i',
    scopes: [
      'source.raku', 'meta.variable.container.raku',
      'variable.other.identifier.raku'
    ]
    expect(tokens[4]).toEqual value: '<',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]
    expect(tokens[8]).toEqual value: '#',
    scopes: [
      'source.raku', 'comment.line.number-sign.raku',
      'punctuation.definition.comment.raku'
    ]

  it "Issue №38 array word quoting doesn't end when \\\\ seen at end", ->
    {tokens} = grammar.tokenizeLine '< \\\\>'
    expect(tokens[0]).toEqual value: '<',
    scopes: [ 'source.raku', 'span.keyword.operator.array.words.raku' ]
    expect(tokens[3]).toEqual value: '>',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]

  it "m/\\\\/ regex highlights with two backslash in it", ->
    {tokens} = grammar.tokenizeLine 'm/\\\\/'
    expect(tokens[0]).toEqual value: 'm',
    scopes: [ 'source.raku', 'string.regexp.construct.slash.raku' ]
    expect(tokens[1]).toEqual value: '/',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.slash.raku' ]
    expect(tokens[2]).toEqual value: '\\\\',
    scopes: [ 'source.raku', 'string.regexp.slash.raku' ]
    expect(tokens[3]).toEqual value: '/',
    scopes: [ 'source.raku', 'punctuation.definition.regexp.slash.raku' ]

  it "# regex highlights arbitrary delimiters when using m", ->
    {tokens} = grammar.tokenizeLine 'say m|hi|'

  it "doesn't start regex for routines with regex in them", ->
    {tokens} = grammar.tokenizeLine 'regex_coderef'
    expect(tokens[0]).toEqual value: 'regex_coderef',
    scopes: [ 'source.raku', 'routine.name.raku' ]

  it "Regex doesn't start with just a /", ->
    {tokens} = grammar.tokenizeLine '/'
    expect(tokens[0]).toEqual value: '/',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]

  ## Pod
  it "Pod headers highlight until newline", ->
    lines = grammar.tokenizeLines '''
    =head1 abc
    ethethe head

    trim
    '''
    expect(lines[0][0]).toEqual value: '=',
    scopes: [ 'source.raku', 'storage.modifier.block.abbreviated.raku' ]
    expect(lines[0][1]).toEqual value: 'head1',
    scopes: [
      'source.raku',
      'entity.other.attribute-name.block.abbreviated.raku'
    ]
    expect(lines[1][0]).toEqual value: 'ethethe head',
    scopes: [ 'source.raku', 'entity.name.section.head.abbreviated.raku' ]

  ## Methods
  it "multi sub highlights properly. Issue №26", ->
    {tokens} = grammar.tokenizeLine "multi sub thingy"
    expect(tokens[0]).toEqual value: 'multi',
    scopes: [ 'source.raku', 'storage.type.declarator.multi.raku' ]
    expect(tokens[1]).toEqual value: ' ',
    scopes: [ 'source.raku' ]
    expect(tokens[2]).toEqual value: 'sub',
    scopes: [ 'source.raku', 'storage.type.declarator.type.raku' ]
    expect(tokens[3]).toEqual value: ' ',
    scopes: [ 'source.raku' ]
    expect(tokens[4]).toEqual value: 'thingy',
    scopes: [ 'source.raku', 'entity.name.function.raku' ]
  it "FQ private methods are highlighted properly Issue №8", ->
    {tokens} = grammar.tokenizeLine "self.List::perl;"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.raku', 'variable.language.raku' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]
    expect(tokens[2]).toEqual value: 'List',
    scopes: [ 'source.raku', 'support.type.raku' ]
    expect(tokens[3]).toEqual value: '::',
    scopes: [
      'source.raku',
      'support.function.raku',
      'keyword.operator.colon.raku'
    ]
    expect(tokens[4]).toEqual value: 'perl',
    scopes: [ 'source.raku', 'support.function.raku' ]

  it "self.perl highlights", ->
    {tokens} = grammar.tokenizeLine "self.perl"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.raku', 'variable.language.raku' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]
    expect(tokens[2]).toEqual value: 'perl',
    scopes: [ 'source.raku', 'support.function.raku' ]
  it "Private methods highlight properly. Issue №7", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.raku', 'storage.type.declarator.type.raku' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.raku', 'support.class.method.private.raku' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.raku', 'entity.name.function.raku' ]

  ## Operators
  it "Hex numbers highlight properly with dash-minus in front", ->
    {tokens} = grammar.tokenizeLine "-0x10"
    expect(tokens[0]).toEqual value: '-0x10',
    scopes: [ 'source.raku', 'constant.numeric.radix.raku' ]

  it "Hex numbers highlight properly with plus sign in front", ->
    {tokens} = grammar.tokenizeLine "+0x10"
    expect(tokens[0]).toEqual value: '+0x10',
    scopes: [ 'source.raku', 'constant.numeric.radix.raku' ]
  it "Hex numbers highlight properly with minus sign U2212 in front", ->
    {tokens} = grammar.tokenizeLine "−0x10"
    expect(tokens[0]).toEqual value: '−0x10',
    scopes: [ 'source.raku', 'constant.numeric.radix.raku' ]
  it "Numbers highlight properly with minus sign U2212 in front", ->
    {tokens} = grammar.tokenizeLine "−42"
    expect(tokens[0]).toEqual value: '−42',
    scopes: [ 'source.raku', 'constant.numeric.raku' ]

  it "Numbers highlight properly with no whole number and a sign", ->
    {tokens} = grammar.tokenizeLine "−.42"
    expect(tokens[0]).toEqual value: '−.42',
    scopes: [ 'source.raku', 'constant.numeric.raku' ]

  it "=~= approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "=~="
    expect(tokens[0]).toEqual value: "=~=",
    scopes: [
      'source.raku',
      'meta.operator.non.ligature.raku',
      'keyword.operator.approx-equal.raku'
    ]
  it "≅ approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "≅"
    expect(tokens[0]).toEqual value: "≅",
    scopes: [
      'source.raku',
      'meta.operator.non.ligature.raku',
      'keyword.operator.approx-equal.raku'
    ]
  ## Comments
  it "Multi-line comments with paren start", ->
    {tokens} = grammar.tokenizeLine "#`("
    expect(tokens[0]).toEqual value: '#`(',
    scopes: [ 'source.raku', 'comment.multiline.hash-tick.paren.raku' ]

  ## Quoting {qq[ ]}
  it "qq quoting works if surrounded by curly brackets", ->
    {tokens} = grammar.tokenizeLine "{qq[ ]}"
    expect(tokens[1]).toEqual value: 'qq',
    scopes: [
      'source.raku', 'meta.block.raku',
      'string.quoted.qq.operator.raku'
    ]
  it "qq quoting works if surrounded by parens", ->
    {tokens} = grammar.tokenizeLine "(qq[ ])"
    expect(tokens[1]).toEqual value: 'qq',
    scopes: [
      'source.raku', 'string.quoted.qq.operator.raku'
    ]
  it "Function calls in interpolated strings don't overrun the line", ->
    {tokens} = grammar.tokenizeLine '"$o.n()".s( ) ]);'
    expect(tokens[4]).toEqual value: 'n',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku',
      'support.function.raku'
    ]
    expect(tokens[5]).toEqual value: '()',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku'
    ]
    expect(tokens[7]).toEqual value: '.',
    scopes: [ 'source.raku', 'keyword.operator.generic.raku' ]

  it "Function calls highlight in interpolated strings", ->
    {tokens} = grammar.tokenizeLine '"$b.foo() should)"'
    expect(tokens[1]).toEqual value: '$',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku',
      'variable.other.identifier.sigil.raku'
    ]
    expect(tokens[2]).toEqual value: 'b',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku'
    ]
    expect(tokens[3]).toEqual value: '.',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku',
      'keyword.operator.dot.raku'
    ]
    expect(tokens[4]).toEqual value: 'foo',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku',
      'support.function.raku'
    ]
    expect(tokens[5]).toEqual value: '()',
    scopes: [
      'source.raku', 'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku'
    ]
    expect(tokens[6]).toEqual value: ' should)',
    scopes: [ 'source.raku', 'string.quoted.double.raku' ]

  it "Variables highlight in interpolated strings", ->
    {tokens} = grammar.tokenizeLine '"$var"'
    expect(tokens[0]).toEqual value: '"',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'punctuation.definition.string.begin.raku'
    ]
    expect(tokens[1]).toEqual  value: '$',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku',
      'variable.other.identifier.sigil.raku'
    ]
    expect(tokens[2]).toEqual value: 'var',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'variable.other.identifier.interpolated.raku'
    ]
  it "Angle bracket word quoting works multi-line, when after = sign", ->
    lines = grammar.tokenizeLines """
    my $var = < a b
    c d >
    """
    expect(lines[0][7]).toEqual value: '<',
    scopes: [ 'source.raku', 'span.keyword.operator.array.words.raku' ]

  it "Angle brackets don't quote for less than sign", ->
    {tokens} = grammar.tokenizeLine "while $i < $len"
    expect(tokens[5]).toEqual value: '<',
    scopes: [
      'source.raku',
      'keyword.operator.generic.raku'
    ]
  it "Angle bracket quoting works", ->
    {tokens} = grammar.tokenizeLine "<test>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [
      'source.raku',
      'span.keyword.operator.array.words.raku'
    ]
    expect(tokens[1]).toEqual value: 'test',
    scopes: [ 'source.raku', 'string.array.words.raku' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.raku', 'span.keyword.operator.array.words.raku' ]
  it "Angle bracket quoting works with } in them Issue №2", ->
    {tokens} = grammar.tokenizeLine "<test}>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [ 'source.raku', 'span.keyword.operator.array.words.raku' ]
    expect(tokens[1]).toEqual value: 'test}',
    scopes: [ 'source.raku', 'string.array.words.raku' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.raku', 'span.keyword.operator.array.words.raku' ]

  it "q[TEST] works", ->
    {tokens} = grammar.tokenizeLine "q[TEST]"
    expect(tokens[0]).toEqual value: 'q',
    scopes: [ 'source.raku', 'string.quoted.q.operator.raku' ]
    expect(tokens[1]).toEqual value: '[',
    scopes: [ 'source.raku', 'punctuation.definition.string.raku' ]
    expect(tokens[2]).toEqual value: 'TEST',
    scopes: [ 'source.raku', 'string.quoted.q.bracket.quote.raku' ]

  it "q[] works surrounded by parenthesis", ->
    {tokens} = grammar.tokenizeLine "(q[TEST])"
    expect(tokens[1]).toEqual value: 'q',
    scopes: [ 'source.raku', 'string.quoted.q.operator.raku' ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [ 'source.raku', 'punctuation.definition.string.raku' ]
    expect(tokens[3]).toEqual
    value: 'TEST',
    scopes: [ 'source.raku', 'string.quoted.q.bracket.quote.raku' ]

  it "Escaped variables don't syntax highlight in double quotation marks", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.raku', 'storage.type.declarator.type.raku' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.raku', 'support.class.method.private.raku' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.raku', 'entity.name.function.raku' ]

  ## Pairs
  it "Pairs highlight when no quotes used for key", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check', Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.raku', 'string.pair.key.raku' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.raku', 'keyword.operator.multi-symbol.raku' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.raku',
      'string.quoted.single.single.raku',
      'punctuation.definition.string.begin.raku'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.raku', 'string.quoted.single.single.raku' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.raku',
      'string.quoted.single.single.raku',
      'punctuation.definition.string.end.raku'
    ]
    expect(tokens[5]).toEqual value: ', ',
    scopes: [ 'source.raku' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.raku', 'string.pair.key.raku' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.raku', 'keyword.operator.multi-symbol.raku' ]

  it "Pairs highlight when no quotes used for key and no spaces", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check',Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.raku', 'string.pair.key.raku' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.raku', 'keyword.operator.multi-symbol.raku' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.raku',
      'string.quoted.single.single.raku',
      'punctuation.definition.string.begin.raku'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.raku', 'string.quoted.single.single.raku' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.raku',
      'string.quoted.single.single.raku',
      'punctuation.definition.string.end.raku'
    ]
    expect(tokens[5]).toEqual value: ',',
    scopes: [ 'source.raku' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.raku', 'string.pair.key.raku' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.raku', 'keyword.operator.multi-symbol.raku' ]

  ## Variables
  it "Method made highlights", ->
    {tokens} = grammar.tokenizeLine "Calculator.made"
    expect(tokens[2]).toEqual value: 'made',
    scopes: [ 'source.raku', 'keyword.control.flowcontrol.regex.raku' ]
  it "Regex named captures highlight", ->
    {tokens} =
    grammar.tokenizeLine "$<captured>"
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.raku',
      'meta.match.variable.raku',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.raku',
      'meta.match.variable.raku',
      'support.class.match.name.delimiter.regexp.raku'
    ]
    expect(tokens[2]).toEqual value: 'captured',
    scopes: [
      'source.raku',
      'meta.match.variable.raku',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[3]).toEqual value: '>',
    scopes: [
      'source.raku',
      'meta.match.variable.raku',
      'support.class.match.name.delimiter.regexp.raku'
    ]
  it "regex rule calc-op:sym<add> highlights.", ->
    {tokens} = grammar.tokenizeLine 'rule calc-op:sym<add>'
    expect(tokens[3]).toEqual value: ':',
    scopes: [
      'source.raku', 'meta.regexp.named.raku',
      'meta.regexp.named.adverb.raku',
      'punctuation.definition.regexp.adverb.raku'
    ]
    expect(tokens[4]).toEqual value: 'sym',
    scopes: [
      'source.raku',
      'meta.regexp.named.raku',
      'meta.regexp.named.adverb.raku',
      'support.type.class.adverb.raku'
    ]
    expect(tokens[5]).toEqual value: '<',
    scopes: [ 'source.raku', 'meta.regexp.named.raku' ]
    expect(tokens[6]).toEqual value: 'add',
    scopes: [
      'source.raku',
      'meta.regexp.named.raku',
      'string.array.words.raku'
    ]

  it "regex grammar method ops highlight. Issue №12", ->
    {tokens} = grammar.tokenizeLine 'method calc-op:sym<add>'
    expect(tokens[3]).toEqual value: ':',
    scopes: [
      'source.raku',
      'punctuation.definition.function.adverb.raku'
    ]
    expect(tokens[4]).toEqual value: 'sym',
    scopes: [
      'source.raku',
      'support.type.class.adverb.raku'
    ]
    expect(tokens[5]).toEqual value: '<',
    scopes: [
      'source.raku',
      'span.keyword.operator.array.words.raku'
    ]
    expect(tokens[6]).toEqual value: 'add',
    scopes: [
      'source.raku',
      'string.array.words.raku'
    ]

  it "Regex named captures highlight in double quoted strings. Issue №9", ->
    {tokens} =
    grammar.tokenizeLine '"$<captured>"'
    expect(tokens[0]).toEqual value: '"',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'punctuation.definition.string.begin.raku'
    ]
    expect(tokens[1]).toEqual value: '$',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'meta.match.variable.raku',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[2]).toEqual value: '<',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'meta.match.variable.raku',
      'support.class.match.name.delimiter.regexp.raku'
    ]
    expect(tokens[3]).toEqual value: 'captured',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'meta.match.variable.raku',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[4]).toEqual value: '>',
    scopes: [
      'source.raku',
      'string.quoted.double.raku',
      'meta.match.variable.raku',
      'support.class.match.name.delimiter.regexp.raku'
    ]
  ## Regex
  it "Hyphens and ' are allowed in grammar rules", ->
    {tokens} =
    grammar.tokenizeLine "rule calc's-op"
    expect(tokens[0]).toEqual value: 'rule',
    scopes: [
      'source.raku',
      'meta.regexp.named.raku',
      'storage.type.declare.regexp.named.raku'
    ]
    expect(tokens[2]).toEqual value: "calc's-op",
    scopes: [
      'source.raku',
      'meta.regexp.named.raku',
      'entity.name.function.regexp.named.raku'
    ]
##The line below is fudged due to an Atom bug that only shows up when testing
##intermittently. Please unfudge and test before release.
  it "Regex hex highlights in character classes Issue №10. Atom Issue #5025", ->
    {tokens} =
    grammar.tokenizeLine '/<[ \\x[99] ]>/'
    expect(tokens[0]).toEqual value: '/',
    scopes: [
      'source.raku',
      'punctuation.definition.regexp.raku'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'punctuation.delimiter.property.regexp.raku'
    ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'keyword.operator.charclass.open.regexp.raku'
    ]
    expect(tokens[3]).toEqual value: ' ',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku'
    ]
    expect(tokens[4]).toEqual value: '\\x',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku',
      'punctuation.hex.raku',
      'keyword.punctuation.hex.raku'
    ]
    expect(tokens[5]).toEqual value: '[',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku',
      'punctuation.hex.raku',
      'keyword.operator.bracket.open.raku'
    ]
    expect(tokens[6]).toEqual value: '99',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku',
      'punctuation.hex.raku',
      'routine.name.hex.raku'
    ]
    expect(tokens[7]).toEqual value: ']',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku',
      'punctuation.hex.raku',
      'keyword.operator.bracket.close.raku'
    ]
    expect(tokens[8]).toEqual value: ' ',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'constant.character.custom.property.regexp.raku'
    ]
    expect(tokens[9]).toEqual value: ']',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'keyword.operator.charclass.close.regexp.raku'
    ]
    expect(tokens[10]).toEqual value: '>',
    scopes: [
      'source.raku',
      'string.regexp.raku',
      'meta.property.regexp.raku',
      'punctuation.delimiter.property.regexp.raku'
    ]
    expect(tokens[11]).toEqual value: '/',
    scopes: [
      'source.raku',
      'punctuation.definition.regexp.raku'
    ]

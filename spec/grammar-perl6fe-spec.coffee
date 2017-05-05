## Please note if you put hash symbols in any of the `it´ lines it will
## skip the test. This can be useful, but for refering to Issue numbers
## please use the № symbol in place of a hash if the test passes, and
## a hash if it currently fails.

## Keep ALL lines at _exactly_ 80 characters or _less_ or Travis CI's Linter
## will cause the build to fail. Maybe there's a way around this…

describe "Perl 6 FE grammar", ->
  grammar = null
  grammarRE = null
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl6")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl6")
      grammarRE = atom.grammars.grammarForScopeName("source.regexp.perl6")

  ## Sanity checks
  it "parses source.perl6", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl6"

  it "parses source.regexp.perl6", ->
    expect(grammarRE).toBeDefined()
    expect(grammarRE.scopeName).toBe "source.regexp.perl6"

  ## First line language detection
  it "use v6 works", ->
    lne = " use v6;"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()
  it "First line: =comment detected as Perl 6", ->
    lne = " =comment detected as Perl 6"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()
  it " =begin pod works", ->
    lne = " =begin pod"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull()

  # Types
  it "Same highlights as a type", ->
    {tokens} = grammar.tokenizeLine 'Same'
    expect(tokens[0]).toEqual value: 'Same',
    scopes: [ 'source.perl6', 'support.type.perl6' ]

 ## Bugs
# $line.match(/^\s*$/)
  it "bracket regex with s: highlights properly № 60", ->
    {tokens} = grammar.tokenizeLine "s:g { [^ | <?after '\\\\'>] <!before '..\\\\'> <-[\\\\]>+ '\\\\..' ['\\\\' | $ ] } = '' { };"
    expect(tokens[1]).toEqual value: ':g',
    scopes: [ 'source.perl6', 'entity.name.section.adverb.regexp.perl6' ]
    expect(tokens[3]).toEqual value: '{',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]
    expect(tokens[5]).toEqual value: '^',
    scopes: [ 'source.perl6', 'fstring.regexp.perl6',
    'entity.name.section.boundary.regexp.perl6' ]

  it "bracket before number does not accidently highlight as a number № 58", ->
    {tokens} = grammar.tokenizeLine "{1}"
    expect(tokens[1]).toEqual value: '1',
    scopes: [ 'source.perl6', 'meta.block.perl6',
    'constant.numeric.perl6' ]

  it ":= assignment highlights as one token and correctly", ->
    {tokens} = grammar.tokenizeLine "10 := 11"
    expect(tokens[2]).toEqual value: ':=',
    scopes: [ 'source.perl6', 'storage.modifier.assignment.perl6' ]

  it "single quotes in regex don't break", ->
    {tokens} = grammar.tokenizeLine "/ '/' /"
    expect(tokens[0]).toEqual value: '/',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]
    expect(tokens[2]).toEqual value: "'",
    scopes: [ 'source.perl6', 'string.regexp.perl6',
    'string.literal.perl6' ]
    expect(tokens[5]).toEqual value: ' /',
    scopes: [ 'source.perl6', 'string.quoted.single.single.perl6' ]

  it "m:i{blah} highlights as regex", ->
    {tokens} = grammar.tokenizeLine "m:i{ blah }"
    expect(tokens[2]).toEqual value: '{',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]

  it "^-10 highlights as a number", ->
    {tokens} = grammar.tokenizeLine "^-10"
    expect(tokens[0]).toEqual value: '^-10',
    scopes: [ 'source.perl6', 'constant.numeric.perl6' ]

  it "Regex using .match highlights $line.match(/^\\s*$/)", ->
    {tokens} = grammar.tokenizeLine '$line.match(/^\\s*$/)'
    expect(tokens[3]).toEqual value: 'match',
    scopes: [ 'source.perl6', 'support.function.perl6' ]
    expect(tokens[5]).toEqual value: '/',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]

  it "Bare Regex with ~~ before it highlights", ->
    {tokens} = grammar.tokenizeLine '"t" ~~ /^\\s$/'
    expect(tokens[6]).toEqual value: '/',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]

  it "proto method does not highlight properly. Issue № 31", ->
    {tokens} = grammar.tokenizeLine 'proto method rename(|) { * }'
    expect(tokens[0]).toEqual value: 'proto',
    scopes: [ 'source.perl6', 'storage.type.declarator.multi.perl6' ]
    expect(tokens[2]).toEqual value: 'method',
    scopes: [ 'source.perl6', 'storage.type.declarator.type.perl6' ]
    expect(tokens[4]).toEqual value: 'rename',
    scopes: [ 'source.perl6', 'entity.name.function.perl6' ]

  it "Putting spaces around / division operator highlights properly. Issue № 34", ->
    {tokens} = grammar.tokenizeLine 'isa-ok(1 / 4, Rat, "/ makes a Rat");'
    expect(tokens[4]).toEqual value: '/',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]

  it "Two variables in a row don't allow hyphens in variable name. Issue № 40", ->
    {tokens} = grammar.tokenizeLine '$reverse-solidus$reverse-solidus'
    expect(tokens[3]).toEqual value: 'reverse-solidus',
    scopes: [
      'source.perl6', 'meta.variable.container.perl6',
      'variable.other.identifier.perl6'
    ]

  it "Keywords that are flow control highlight as methods when used as methods. Issue № 35", ->
    {tokens} = grammar.tokenizeLine '$p2.break'
    expect(tokens[3]).toEqual value: 'break',
    scopes: [ 'source.perl6', 'support.function.perl6' ]

  it "1e-6 highlights as a number. Issue № 35", ->
    {tokens} = grammar.tokenizeLine '1e-6'
    expect(tokens[0]).toEqual value: '1e-6',
    scopes: [ 'source.perl6', 'constant.numeric.perl6' ]

  it "Issue № 36. Variables highlight correctly if they contain any non-ASCII characters ", ->
    {tokens} = grammar.tokenizeLine '$ΔxAB'
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.perl6', 'meta.variable.container.perl6',
      'variable.other.identifier.sigil.perl6'
    ]
    expect(tokens[1]).toEqual value: 'ΔxAB',
    scopes: [
      'source.perl6', 'meta.variable.container.perl6',
      'variable.other.identifier.perl6'
    ]

  it "Issue № 39. Angle bracket quoting needlessly starts", ->
    {tokens} = grammar.tokenizeLine '$i++ < 3; # >'
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.perl6',
      'meta.variable.container.perl6',
      'variable.other.identifier.sigil.perl6'
    ]
    expect(tokens[1]).toEqual value: 'i',
    scopes: [
      'source.perl6', 'meta.variable.container.perl6',
      'variable.other.identifier.perl6'
    ]
    expect(tokens[4]).toEqual value: '<',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]
    expect(tokens[8]).toEqual value: '#',
    scopes: [
      'source.perl6', 'comment.line.number-sign.perl6',
      'punctuation.definition.comment.perl6'
    ]

  it "Issue №38 array word quoting doesn't end when \\\\ seen at end", ->
    {tokens} = grammar.tokenizeLine '< \\\\>'
    expect(tokens[0]).toEqual value: '<',
    scopes: [ 'source.perl6', 'span.keyword.operator.array.words.perl6' ]
    expect(tokens[3]).toEqual value: '>',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]

  it "m/\\\\/ regex highlights with two backslash in it", ->
    {tokens} = grammar.tokenizeLine 'm/\\\\/'
    expect(tokens[0]).toEqual value: 'm',
    scopes: [ 'source.perl6', 'string.regexp.construct.perl6' ]
    expect(tokens[1]).toEqual value: '/',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]
    expect(tokens[2]).toEqual value: '\\\\',
    scopes: [ 'source.perl6', 'string.regexp.perl6' ]
    expect(tokens[3]).toEqual value: '/',
    scopes: [ 'source.perl6', 'punctuation.definition.regexp.perl6' ]

  it "# regex highlights arbitrary delimiters when using m", ->
    {tokens} = grammar.tokenizeLine 'say m|hi|'

  it "doesn't start regex for routines with regex in them", ->
    {tokens} = grammar.tokenizeLine 'regex_coderef'
    expect(tokens[0]).toEqual value: 'regex_coderef',
    scopes: [ 'source.perl6', 'routine.name.perl6' ]

  it "Regex doesn't start with just a /", ->
    {tokens} = grammar.tokenizeLine '/'
    expect(tokens[0]).toEqual value: '/',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]

  ## Pod
  it "Pod headers highlight until newline", ->
    lines = grammar.tokenizeLines '''
    =head1 abc
    ethethe head

    trim
    '''
    expect(lines[0][0]).toEqual value: '=',
    scopes: [ 'source.perl6', 'storage.modifier.block.abbreviated.perl6' ]
    expect(lines[0][1]).toEqual value: 'head1',
    scopes: [
      'source.perl6',
      'entity.other.attribute-name.block.abbreviated.perl6'
    ]
    expect(lines[1][0]).toEqual value: 'ethethe head',
    scopes: [ 'source.perl6', 'entity.name.section.head.abbreviated.perl6' ]

  ## Methods
  it "multi sub highlights properly. Issue №26", ->
    {tokens} = grammar.tokenizeLine "multi sub thingy"
    expect(tokens[0]).toEqual value: 'multi',
    scopes: [ 'source.perl6', 'storage.type.declarator.multi.perl6' ]
    expect(tokens[1]).toEqual value: ' ',
    scopes: [ 'source.perl6' ]
    expect(tokens[2]).toEqual value: 'sub',
    scopes: [ 'source.perl6', 'storage.type.declarator.type.perl6' ]
    expect(tokens[3]).toEqual value: ' ',
    scopes: [ 'source.perl6' ]
    expect(tokens[4]).toEqual value: 'thingy',
    scopes: [ 'source.perl6', 'entity.name.function.perl6' ]
  it "FQ private methods are highlighted properly Issue №8", ->
    {tokens} = grammar.tokenizeLine "self.List::perl;"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.perl6', 'variable.language.perl6' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]
    expect(tokens[2]).toEqual value: 'List',
    scopes: [ 'source.perl6', 'support.type.perl6' ]
    expect(tokens[3]).toEqual value: '::',
    scopes: [
      'source.perl6',
      'support.function.perl6',
      'keyword.operator.colon.perl6'
    ]
    expect(tokens[4]).toEqual value: 'perl',
    scopes: [ 'source.perl6', 'support.function.perl6' ]

  it "self.perl highlights", ->
    {tokens} = grammar.tokenizeLine "self.perl"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.perl6', 'variable.language.perl6' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]
    expect(tokens[2]).toEqual value: 'perl',
    scopes: [ 'source.perl6', 'support.function.perl6' ]
  it "Private methods highlight properly. Issue №7", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.perl6', 'storage.type.declarator.type.perl6' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.perl6', 'support.class.method.private.perl6' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.perl6', 'entity.name.function.perl6' ]

  ## Operators
  it "Hex numbers highlight properly with dash-minus in front", ->
    {tokens} = grammar.tokenizeLine "-0x10"
    expect(tokens[0]).toEqual value: '-0x10',
    scopes: [ 'source.perl6', 'constant.numeric.radix.perl6' ]

  it "Hex numbers highlight properly with plus sign in front", ->
    {tokens} = grammar.tokenizeLine "+0x10"
    expect(tokens[0]).toEqual value: '+0x10',
    scopes: [ 'source.perl6', 'constant.numeric.radix.perl6' ]
  it "Hex numbers highlight properly with minus sign U2212 in front", ->
    {tokens} = grammar.tokenizeLine "−0x10"
    expect(tokens[0]).toEqual value: '−0x10',
    scopes: [ 'source.perl6', 'constant.numeric.radix.perl6' ]
  it "Numbers highlight properly with minus sign U2212 in front", ->
    {tokens} = grammar.tokenizeLine "−42"
    expect(tokens[0]).toEqual value: '−42',
    scopes: [ 'source.perl6', 'constant.numeric.perl6' ]

  it "Numbers highlight properly with no whole number and a sign", ->
    {tokens} = grammar.tokenizeLine "−.42"
    expect(tokens[0]).toEqual value: '−.42',
    scopes: [ 'source.perl6', 'constant.numeric.perl6' ]

  it "=~= approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "=~="
    expect(tokens[0]).toEqual value: "=~=",
    scopes: [
      'source.perl6',
      'meta.operator.non.ligature.perl6',
      'keyword.operator.approx-equal.perl6'
    ]
  it "≅ approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "≅"
    expect(tokens[0]).toEqual value: "≅",
    scopes: [
      'source.perl6',
      'meta.operator.non.ligature.perl6',
      'keyword.operator.approx-equal.perl6'
    ]
  ## Comments
  it "Multi-line comments with paren start", ->
    {tokens} = grammar.tokenizeLine "#`("
    expect(tokens[0]).toEqual value: '#`(',
    scopes: [ 'source.perl6', 'comment.multiline.hash-tick.paren.perl6' ]

  ## Quoting {qq[ ]}
  it "qq quoting works if surrounded by curly brackets", ->
    {tokens} = grammar.tokenizeLine "{qq[ ]}"
    expect(tokens[1]).toEqual value: 'qq',
    scopes: [
      'source.perl6', 'meta.block.perl6',
      'string.quoted.qq.operator.perl6'
    ]
  it "qq quoting works if surrounded by parens", ->
    {tokens} = grammar.tokenizeLine "(qq[ ])"
    expect(tokens[1]).toEqual value: 'qq',
    scopes: [
      'source.perl6', 'string.quoted.qq.operator.perl6'
    ]
  it "Function calls in interpolated strings don't overrun the line", ->
    {tokens} = grammar.tokenizeLine '"$o.n()".s( ) ]);'
    expect(tokens[4]).toEqual value: 'n',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6',
      'support.function.perl6'
    ]
    expect(tokens[5]).toEqual value: '()',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6'
    ]
    expect(tokens[7]).toEqual value: '.',
    scopes: [ 'source.perl6', 'keyword.operator.generic.perl6' ]

  it "Function calls highlight in interpolated strings", ->
    {tokens} = grammar.tokenizeLine '"$b.foo() should)"'
    expect(tokens[1]).toEqual value: '$',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6',
      'variable.other.identifier.sigil.perl6'
    ]
    expect(tokens[2]).toEqual value: 'b',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6'
    ]
    expect(tokens[3]).toEqual value: '.',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6',
      'keyword.operator.dot.perl6'
    ]
    expect(tokens[4]).toEqual value: 'foo',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6',
      'support.function.perl6'
    ]
    expect(tokens[5]).toEqual value: '()',
    scopes: [
      'source.perl6', 'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6'
    ]
    expect(tokens[6]).toEqual value: ' should)',
    scopes: [ 'source.perl6', 'string.quoted.double.perl6' ]

  it "Variables highlight in interpolated strings", ->
    {tokens} = grammar.tokenizeLine '"$var"'
    expect(tokens[0]).toEqual value: '"',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'punctuation.definition.string.begin.perl6'
    ]
    expect(tokens[1]).toEqual  value: '$',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6',
      'variable.other.identifier.sigil.perl6'
    ]
    expect(tokens[2]).toEqual value: 'var',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'variable.other.identifier.interpolated.perl6'
    ]
  it "Angle bracket word quoting works multi-line, when after = sign", ->
    lines = grammar.tokenizeLines """
    my $var = < a b
    c d >
    """
    expect(lines[0][7]).toEqual value: '<',
    scopes: [ 'source.perl6', 'span.keyword.operator.array.words.perl6' ]

  it "Angle brackets don't quote for less than sign", ->
    {tokens} = grammar.tokenizeLine "while $i < $len"
    expect(tokens[5]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'keyword.operator.generic.perl6'
    ]
  it "Angle bracket quoting works", ->
    {tokens} = grammar.tokenizeLine "<test>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'span.keyword.operator.array.words.perl6'
    ]
    expect(tokens[1]).toEqual value: 'test',
    scopes: [ 'source.perl6', 'string.array.words.perl6' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.perl6', 'span.keyword.operator.array.words.perl6' ]
  it "Angle bracket quoting works with } in them Issue №2", ->
    {tokens} = grammar.tokenizeLine "<test}>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [ 'source.perl6', 'span.keyword.operator.array.words.perl6' ]
    expect(tokens[1]).toEqual value: 'test}',
    scopes: [ 'source.perl6', 'string.array.words.perl6' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.perl6', 'span.keyword.operator.array.words.perl6' ]

  it "q[TEST] works", ->
    {tokens} = grammar.tokenizeLine "q[TEST]"
    expect(tokens[0]).toEqual value: 'q',
    scopes: [ 'source.perl6', 'string.quoted.q.operator.perl6' ]
    expect(tokens[1]).toEqual value: '[',
    scopes: [ 'source.perl6', 'punctuation.definition.string.perl6' ]
    expect(tokens[2]).toEqual value: 'TEST',
    scopes: [ 'source.perl6', 'string.quoted.q.bracket.quote.perl6' ]

  it "q[] works surrounded by parenthesis", ->
    {tokens} = grammar.tokenizeLine "(q[TEST])"
    expect(tokens[1]).toEqual value: 'q',
    scopes: [ 'source.perl6', 'string.quoted.q.operator.perl6' ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [ 'source.perl6', 'punctuation.definition.string.perl6' ]
    expect(tokens[3]).toEqual
    value: 'TEST',
    scopes: [ 'source.perl6', 'string.quoted.q.bracket.quote.perl6' ]

  it "Escaped variables don't syntax highlight in double quotation marks", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.perl6', 'storage.type.declarator.type.perl6' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.perl6', 'support.class.method.private.perl6' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.perl6', 'entity.name.function.perl6' ]

  ## Pairs
  it "Pairs highlight when no quotes used for key", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check', Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.perl6', 'string.pair.key.perl6' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.perl6', 'keyword.operator.multi-symbol.perl6' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.perl6',
      'string.quoted.single.single.perl6',
      'punctuation.definition.string.begin.perl6'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.perl6', 'string.quoted.single.single.perl6' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.perl6',
      'string.quoted.single.single.perl6',
      'punctuation.definition.string.end.perl6'
    ]
    expect(tokens[5]).toEqual value: ', ',
    scopes: [ 'source.perl6' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.perl6', 'string.pair.key.perl6' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.perl6', 'keyword.operator.multi-symbol.perl6' ]

  it "Pairs highlight when no quotes used for key and no spaces", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check',Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.perl6', 'string.pair.key.perl6' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.perl6', 'keyword.operator.multi-symbol.perl6' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.perl6',
      'string.quoted.single.single.perl6',
      'punctuation.definition.string.begin.perl6'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.perl6', 'string.quoted.single.single.perl6' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.perl6',
      'string.quoted.single.single.perl6',
      'punctuation.definition.string.end.perl6'
    ]
    expect(tokens[5]).toEqual value: ',',
    scopes: [ 'source.perl6' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.perl6', 'string.pair.key.perl6' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.perl6', 'keyword.operator.multi-symbol.perl6' ]

  ## Variables
  it "Method made highlights", ->
    {tokens} = grammar.tokenizeLine "Calculator.made"
    expect(tokens[2]).toEqual value: 'made',
    scopes: [ 'source.perl6', 'keyword.control.flowcontrol.regex.perl6' ]
  it "Regex named captures highlight", ->
    {tokens} =
    grammar.tokenizeLine "$<captured>"
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.perl6',
      'meta.match.variable.perl6',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'meta.match.variable.perl6',
      'support.class.match.name.delimiter.regexp.perl6'
    ]
    expect(tokens[2]).toEqual value: 'captured',
    scopes: [
      'source.perl6',
      'meta.match.variable.perl6',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[3]).toEqual value: '>',
    scopes: [
      'source.perl6',
      'meta.match.variable.perl6',
      'support.class.match.name.delimiter.regexp.perl6'
    ]
  it "regex rule calc-op:sym<add> highlights.", ->
    {tokens} = grammar.tokenizeLine 'rule calc-op:sym<add>'
    expect(tokens[3]).toEqual value: ':',
    scopes: [
      'source.perl6', 'meta.regexp.named.perl6',
      'meta.regexp.named.adverb.perl6',
      'punctuation.definition.regexp.adverb.perl6'
    ]
    expect(tokens[4]).toEqual value: 'sym',
    scopes: [
      'source.perl6',
      'meta.regexp.named.perl6',
      'meta.regexp.named.adverb.perl6',
      'support.type.class.adverb.perl6'
    ]
    expect(tokens[5]).toEqual value: '<',
    scopes: [ 'source.perl6', 'meta.regexp.named.perl6' ]
    expect(tokens[6]).toEqual value: 'add',
    scopes: [
      'source.perl6',
      'meta.regexp.named.perl6',
      'string.array.words.perl6'
    ]

  it "regex grammar method ops highlight. Issue №12", ->
    {tokens} = grammar.tokenizeLine 'method calc-op:sym<add>'
    expect(tokens[3]).toEqual value: ':',
    scopes: [
      'source.perl6',
      'punctuation.definition.function.adverb.perl6'
    ]
    expect(tokens[4]).toEqual value: 'sym',
    scopes: [
      'source.perl6',
      'support.type.class.adverb.perl6'
    ]
    expect(tokens[5]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'span.keyword.operator.array.words.perl6'
    ]
    expect(tokens[6]).toEqual value: 'add',
    scopes: [
      'source.perl6',
      'string.array.words.perl6'
    ]

  it "Regex named captures highlight in double quoted strings. Issue №9", ->
    {tokens} =
    grammar.tokenizeLine '"$<captured>"'
    expect(tokens[0]).toEqual value: '"',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'punctuation.definition.string.begin.perl6'
    ]
    expect(tokens[1]).toEqual value: '$',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'meta.match.variable.perl6',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[2]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'meta.match.variable.perl6',
      'support.class.match.name.delimiter.regexp.perl6'
    ]
    expect(tokens[3]).toEqual value: 'captured',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'meta.match.variable.perl6',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[4]).toEqual value: '>',
    scopes: [
      'source.perl6',
      'string.quoted.double.perl6',
      'meta.match.variable.perl6',
      'support.class.match.name.delimiter.regexp.perl6'
    ]
  ## Regex
  it "Hyphens and ' are allowed in grammar rules", ->
    {tokens} =
    grammar.tokenizeLine "rule calc's-op"
    expect(tokens[0]).toEqual value: 'rule',
    scopes: [
      'source.perl6',
      'meta.regexp.named.perl6',
      'storage.type.declare.regexp.named.perl6'
    ]
    expect(tokens[2]).toEqual value: "calc's-op",
    scopes: [
      'source.perl6',
      'meta.regexp.named.perl6',
      'entity.name.function.regexp.named.perl6'
    ]
##The line below is fudged due to an Atom bug that only shows up when testing
##intermittently. Please unfudge and test before release.
  it "Regex hex highlights in character classes Issue №10. Atom Issue #5025", ->
    {tokens} =
    grammar.tokenizeLine '/<[ \\x[99] ]>/'
    expect(tokens[0]).toEqual value: '/',
    scopes: [
      'source.perl6',
      'punctuation.definition.regexp.perl6'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'punctuation.delimiter.property.regexp.perl6'
    ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'keyword.operator.charclass.open.regexp.perl6'
    ]
    expect(tokens[3]).toEqual value: ' ',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6'
    ]
    expect(tokens[4]).toEqual value: '\\x',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6',
      'punctuation.hex.perl6',
      'keyword.punctuation.hex.perl6'
    ]
    expect(tokens[5]).toEqual value: '[',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6',
      'punctuation.hex.perl6',
      'keyword.operator.bracket.open.perl6'
    ]
    expect(tokens[6]).toEqual value: '99',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6',
      'punctuation.hex.perl6',
      'routine.name.hex.perl6'
    ]
    expect(tokens[7]).toEqual value: ']',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6',
      'punctuation.hex.perl6',
      'keyword.operator.bracket.close.perl6'
    ]
    expect(tokens[8]).toEqual value: ' ',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'constant.character.custom.property.regexp.perl6'
    ]
    expect(tokens[9]).toEqual value: ']',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'keyword.operator.charclass.close.regexp.perl6'
    ]
    expect(tokens[10]).toEqual value: '>',
    scopes: [
      'source.perl6',
      'string.regexp.perl6',
      'meta.property.regexp.perl6',
      'punctuation.delimiter.property.regexp.perl6'
    ]
    expect(tokens[11]).toEqual value: '/',
    scopes: [
      'source.perl6',
      'punctuation.definition.regexp.perl6'
    ]

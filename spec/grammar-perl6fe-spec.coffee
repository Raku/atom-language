## Please note if you put hash symbols in any of the `it´ lines it will
## skip the test. This can be useful, but for refering to Issue numbers
## please use the № symbol in place of a hash if the test passes, and
## a hash if it currently fails.

## Keep ALL lines at _exactly_ 80 characters or _less_ or Travis CI's Linter
## will cause the build to fail. Maybe there's a way around this…

describe "Perl 6 FE grammar", ->
  grammar = null
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl6")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl6fe")

  ## Sanity checks
  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl6fe"

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

  ## Methods
  it "FQ private methods are highlighted properly Issue №8", ->
    {tokens} = grammar.tokenizeLine "self.List::perl;"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.perl6fe', 'variable.language.perl6fe' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.perl6fe', 'keyword.operator.generic.perl6fe' ]
    expect(tokens[2]).toEqual value: 'List',
    scopes: [ 'source.perl6fe', 'support.type.perl6fe' ]
    expect(tokens[3]).toEqual value: '::',
    scopes: [
      'source.perl6fe',
      'support.function.perl6fe',
      'keyword.operator.colon.perl6fe'
    ]
    expect(tokens[4]).toEqual value: 'perl',
    scopes: [ 'source.perl6fe', 'support.function.perl6fe' ]

  it "self.perl highlights", ->
    {tokens} = grammar.tokenizeLine "self.perl"
    expect(tokens[0]).toEqual value: 'self',
    scopes: [ 'source.perl6fe', 'variable.language.perl6fe' ]
    expect(tokens[1]).toEqual value: '.',
    scopes: [ 'source.perl6fe', 'keyword.operator.generic.perl6fe' ]
    expect(tokens[2]).toEqual value: 'perl',
    scopes: [ 'source.perl6fe', 'support.function.perl6fe' ]
  it "Private methods highlight properly. Issue №7", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.perl6fe', 'storage.type.declarator.type.perl6fe' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.perl6fe', 'support.class.method.private.perl6fe' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.perl6fe', 'entity.name.function.perl6fe' ]

  ## Operators
  it "=~= approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "=~="
    expect(tokens[0]).toEqual value: "=~=",
    scopes: [
      'source.perl6fe',
      'meta.operator.non.ligature.perl6fe',
      'keyword.operator.approx-equal.perl6fe'
    ]
  it "≅ approximately-equal to operator highlights properly", ->
    {tokens} = grammar.tokenizeLine "≅"
    expect(tokens[0]).toEqual value: "≅",
    scopes: [
      'source.perl6fe',
      'meta.operator.non.ligature.perl6fe',
      'keyword.operator.approx-equal.perl6fe'
    ]
  ## Comments
  it "Multi-line comments with paren start", ->
    {tokens} = grammar.tokenizeLine "#`("
    expect(tokens[0]).toEqual value: '#`(',
    scopes: [ 'source.perl6fe', 'comment.multiline.hash-tick.paren.perl6fe' ]

  ## Quoting
  it "Angle bracket word quoting works multi-line, when after = sign", ->
    lines = grammar.tokenizeLines """
    my $var = < a b
    c d >
    """
    expect(lines[0][7]).toEqual value: '<',
    scopes: [ 'source.perl6fe', 'span.keyword.operator.array.words.perl6fe' ]

  it "Angle brackets don't quote for less than sign", ->
    {tokens} = grammar.tokenizeLine "while $i < $len"
    expect(tokens[5]).toEqual value: '<',
    scopes: [
      'source.perl6fe',
      'keyword.operator.generic.perl6fe'
    ]
  it "Angle bracket quoting works", ->
    {tokens} = grammar.tokenizeLine "<test>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [
      'source.perl6fe',
      'span.keyword.operator.array.words.perl6fe'
    ]
    expect(tokens[1]).toEqual value: 'test',
    scopes: [ 'source.perl6fe', 'string.array.words.perl6fe' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.perl6fe', 'span.keyword.operator.array.words.perl6fe' ]
  it "Angle bracket quoting works with } in them Issue №2", ->
    {tokens} = grammar.tokenizeLine "<test}>"
    expect(tokens[0]).toEqual value: '<',
    scopes: [ 'source.perl6fe', 'span.keyword.operator.array.words.perl6fe' ]
    expect(tokens[1]).toEqual value: 'test}',
    scopes: [ 'source.perl6fe', 'string.array.words.perl6fe' ]
    expect(tokens[2]).toEqual value: '>',
    scopes: [ 'source.perl6fe', 'span.keyword.operator.array.words.perl6fe' ]

  it "q[TEST] works", ->
    {tokens} = grammar.tokenizeLine "q[TEST]"
    expect(tokens[0]).toEqual value: 'q',
    scopes: [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[1]).toEqual value: '[',
    scopes: [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[2]).toEqual value: 'TEST',
    scopes: [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]

  it "q[] works surrounded by parenthesis", ->
    {tokens} = grammar.tokenizeLine "(q[TEST])"
    expect(tokens[1]).toEqual value: 'q',
    scopes: [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[3]).toEqual
    value: 'TEST',
    scopes: [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]

  it "Escaped variables don't syntax highlight in double quotation marks", ->
    {tokens} =
    grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value: 'method',
    scopes: [ 'source.perl6fe', 'storage.type.declarator.type.perl6fe' ]
    expect(tokens[2]).toEqual value: '!',
    scopes: [ 'source.perl6fe', 'support.class.method.private.perl6fe' ]
    expect(tokens[3]).toEqual value: 'wrap-decoder',
    scopes: [ 'source.perl6fe', 'entity.name.function.perl6fe' ]

  ## Pairs
  it "Pairs highlight when no quotes used for key", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check', Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.perl6fe', 'string.pair.key.perl6fe' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.perl6fe', 'keyword.operator.multi-symbol.perl6fe' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.perl6fe',
      'string.quoted.single.single.perl6fe',
      'punctuation.definition.string.begin.perl6fe'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.perl6fe', 'string.quoted.single.single.perl6fe' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.perl6fe',
      'string.quoted.single.single.perl6fe',
      'punctuation.definition.string.end.perl6fe'
    ]
    expect(tokens[5]).toEqual value: ', ',
    scopes: [ 'source.perl6fe' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.perl6fe', 'string.pair.key.perl6fe' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.perl6fe', 'keyword.operator.multi-symbol.perl6fe' ]

  it "Pairs highlight when no quotes used for key and no spaces", ->
    {tokens} =
    grammar.tokenizeLine "NFKD_QC=>'NFKD_Quick_Check',Ext=>'Extender'"
    expect(tokens[0]).toEqual value: 'NFKD_QC',
    scopes: [ 'source.perl6fe', 'string.pair.key.perl6fe' ]
    expect(tokens[1]).toEqual value: '=>',
    scopes: [ 'source.perl6fe', 'keyword.operator.multi-symbol.perl6fe' ]
    expect(tokens[2]).toEqual value: '\'',
    scopes: [
      'source.perl6fe',
      'string.quoted.single.single.perl6fe',
      'punctuation.definition.string.begin.perl6fe'
    ]
    expect(tokens[3]).toEqual value: 'NFKD_Quick_Check',
    scopes: [ 'source.perl6fe', 'string.quoted.single.single.perl6fe' ]
    expect(tokens[4]).toEqual value: "'",
    scopes: [
      'source.perl6fe',
      'string.quoted.single.single.perl6fe',
      'punctuation.definition.string.end.perl6fe'
    ]
    expect(tokens[5]).toEqual value: ',',
    scopes: [ 'source.perl6fe' ]
    expect(tokens[6]).toEqual value: 'Ext',
    scopes: [ 'source.perl6fe', 'string.pair.key.perl6fe' ]
    expect(tokens[7]).toEqual value: '=>',
    scopes: [ 'source.perl6fe', 'keyword.operator.multi-symbol.perl6fe' ]

  ## Variables
  it "Regex named captures highlight", ->
    {tokens} =
    grammar.tokenizeLine "$<captured>"
    expect(tokens[0]).toEqual value: '$',
    scopes: [
      'source.perl6fe',
      'meta.match.variable.perl6fe',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.perl6fe',
      'meta.match.variable.perl6fe',
      'support.class.match.name.delimiter.regexp.perl6fe'
    ]
    expect(tokens[2]).toEqual value: 'captured',
    scopes: [
      'source.perl6fe',
      'meta.match.variable.perl6fe',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[3]).toEqual value: '>',
    scopes: [
      'source.perl6fe',
      'meta.match.variable.perl6fe',
      'support.class.match.name.delimiter.regexp.perl6fe'
    ]
  it "Regex named captures highlight in double quoted strings. Issue №9", ->
    {tokens} =
    grammar.tokenizeLine '"$<captured>"'
    expect(tokens[0]).toEqual value: '"',
    scopes: [
      'source.perl6fe',
      'string.quoted.double.perl6fe',
      'punctuation.definition.string.begin.perl6fe'
    ]
    expect(tokens[1]).toEqual value: '$',
    scopes: [
      'source.perl6fe',
      'string.quoted.double.perl6fe',
      'meta.match.variable.perl6fe',
      'variable.other.identifier.sigil.regexp.perl6'
    ]
    expect(tokens[2]).toEqual value: '<',
    scopes: [
      'source.perl6fe',
      'string.quoted.double.perl6fe',
      'meta.match.variable.perl6fe',
      'support.class.match.name.delimiter.regexp.perl6fe'
    ]
    expect(tokens[3]).toEqual value: 'captured',
    scopes: [
      'source.perl6fe',
      'string.quoted.double.perl6fe',
      'meta.match.variable.perl6fe',
      'variable.other.identifier.regexp.perl6'
    ]
    expect(tokens[4]).toEqual value: '>',
    scopes: [
      'source.perl6fe',
      'string.quoted.double.perl6fe',
      'meta.match.variable.perl6fe',
      'support.class.match.name.delimiter.regexp.perl6fe'
    ]
  ## Regex
  it "Hyphens and ' are allowed in grammar rules", ->
    {tokens} =
    grammar.tokenizeLine "rule calc's-op"
    expect(tokens[0]).toEqual value: 'rule',
    scopes: [
      'source.perl6fe',
      'meta.regexp.named.perl6fe',
      'storage.type.declare.regexp.named.perl6fe'
    ]
    expect(tokens[2]).toEqual value: "calc's-op",
    scopes: [
      'source.perl6fe',
      'meta.regexp.named.perl6fe',
      'entity.name.function.regexp.named.perl6fe'
    ]

  it "Regex hex highlights in character classes Issue №10", ->
    {tokens} =
    grammar.tokenizeLine '/<[ \\x[99] ]>/'
    expect(tokens[0]).toEqual value: '/',
    scopes: [
      'source.perl6fe',
      'punctuation.definition.regexp.perl6fe'
    ]
    expect(tokens[1]).toEqual value: '<',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'punctuation.delimiter.property.regexp.perl6fe'
    ]
    expect(tokens[2]).toEqual value: '[',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'keyword.operator.charclass.open.regexp.perl6fe'
    ]
    expect(tokens[3]).toEqual value: ' ',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe'
    ]
    expect(tokens[4]).toEqual value: '\\x',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe',
      'punctuation.hex.perl6fe',
      'keyword.punctuation.hex.perl6fe'
    ]
    expect(tokens[5]).toEqual value: '[',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe',
      'punctuation.hex.perl6fe',
      'keyword.operator.bracket.open.perl6fe'
    ]
    expect(tokens[6]).toEqual value: '99',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe',
      'punctuation.hex.perl6fe',
      'routine.name.hex.perl6fe'
    ]
    expect(tokens[7]).toEqual value: ']',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe',
      'punctuation.hex.perl6fe',
      'keyword.operator.bracket.close.perl6fe'
    ]
    expect(tokens[8]).toEqual value: ' ',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'constant.character.custom.property.regexp.perl6fe'
    ]
    expect(tokens[9]).toEqual value: ']',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'keyword.operator.charclass.close.regexp.perl6fe'
    ]
    expect(tokens[10]).toEqual value: '>',
    scopes: [
      'source.perl6fe',
      'string.regexp.perl6fe',
      'meta.property.regexp.perl6fe',
      'punctuation.delimiter.property.regexp.perl6fe'
    ]
    expect(tokens[11]).toEqual value: '/',
    scopes: [
      'source.perl6fe',
      'punctuation.definition.regexp.perl6fe'
    ]

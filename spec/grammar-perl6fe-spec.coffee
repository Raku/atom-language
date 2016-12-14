describe "Perl 6 FE grammar", ->
  grammar = null
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl6")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl6fe")
  # Sanity checks
  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl6fe"
  # First line language detection
  it "use v6 works", ->
    line = " use v6;"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()
  it "First line: =comment detected as Perl 6", ->
    line = " =comment detected as Perl 6"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()
  it " =begin pod works", ->
    line = " =begin pod"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()
  it "FQ private methods are highlighted properly Issue 8", ->
    {tokens} = grammar.tokenizeLine "self.List::perl;"
    expect(tokens[0]).toEqual value : 'self',
    scopes : [ 'source.perl6fe', 'variable.language.perl6fe' ]
    expect(tokens[1]).toEqual value : '.',
    scopes : [ 'source.perl6fe', 'keyword.operator.generic.perl6fe' ]
    expect(tokens[2]).toEqual value : 'List',
    scopes : [ 'source.perl6fe', 'support.type.perl6fe' ]
    expect(tokens[3]).toEqual value : '::',
    scopes : [ 'source.perl6fe', 'support.function.perl6fe', 'keyword.operator.colon.perl6fe' ]
    expect(tokens[4]).toEqual value : 'perl',
    scopes : [ 'source.perl6fe', 'support.function.perl6fe' ]
  it "self.perl highlights", ->
    {tokens} = grammar.tokenizeLine "self.perl"
    expect(tokens[0]).toEqual value : 'self',
    scopes : [ 'source.perl6fe', 'variable.language.perl6fe' ]
    expect(tokens[1]).toEqual value : '.',
    scopes : [ 'source.perl6fe', 'keyword.operator.generic.perl6fe' ]
    expect(tokens[2]).toEqual value : 'perl',
    scopes : [ 'source.perl6fe', 'support.function.perl6fe' ]

  it "Multi-line comments with paren start", ->
    {tokens} = grammar.tokenizeLine "#`("
    expect(tokens[0]).toEqual value: '#`(',
    scopes : [ 'source.perl6fe', 'comment.multiline.hash-tick.paren.perl6fe' ]

  it "q[TEST] works", ->
    {tokens} = grammar.tokenizeLine "q[TEST]"
    expect(tokens[0]).toEqual value : 'q',
    scopes : [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[1]).toEqual value : '[',
    scopes : [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[2]).toEqual value : 'TEST',
    scopes : [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]

  it "q[] works surrounded by parenthesis", ->
    {tokens} = grammar.tokenizeLine "(q[TEST])"
    expect(tokens[1]).toEqual value : 'q',
    scopes : [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[2]).toEqual value : '[',
    scopes : [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[3]).toEqual
    value : 'TEST',
    scopes : [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]

  it "Private methods highlight properly. Issue 7", ->
    {tokens} = grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value : 'method',
    scopes : [ 'source.perl6fe', 'storage.type.declarator.type.perl6fe' ]
    expect(tokens[2]).toEqual value : '!',
    scopes : [ 'source.perl6fe', 'support.class.method.private.perl6fe' ]
    expect(tokens[3]).toEqual value : 'wrap-decoder',
    scopes : [ 'source.perl6fe', 'entity.name.function.perl6fe' ]
  it "Escaped variables don't syntax highlight in double quotation marks", ->
    {tokens} = grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value : 'method',
    scopes : [ 'source.perl6fe', 'storage.type.declarator.type.perl6fe' ]
    expect(tokens[2]).toEqual value : '!',
    scopes : [ 'source.perl6fe', 'support.class.method.private.perl6fe' ]
    expect(tokens[3]).toEqual value : 'wrap-decoder',
    scopes : [ 'source.perl6fe', 'entity.name.function.perl6fe' ]

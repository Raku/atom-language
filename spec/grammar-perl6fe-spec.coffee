describe "Perl 6 FE grammar", ->
  grammar = null
#method !capture(\callbacks,\std,\the-supply)
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-perl6")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.perl6fe")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.perl6fe"

  it "use v6 works", ->
    line = " use v6;"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()
  #it "=begin pod works", ->
  #  line = " =comment Perl 6 is the Best!"
  #  expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()
  it "Multi-line comments with paren start", ->
    {tokens} = grammar.tokenizeLine "#`("
    expect(tokens[0]).toEqual value: '#`(', scopes : [ 'source.perl6fe', 'comment.multiline.hash-tick.paren.perl6fe' ]

  it "q[TEST] works", ->
    {tokens} = grammar.tokenizeLine "q[TEST]"
    expect(tokens[0]).toEqual value : 'q', scopes : [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[1]).toEqual value : '[', scopes : [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[2]).toEqual value : 'TEST', scopes : [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]

  it "q[] works surrounded by parenthesis", ->
    {tokens} = grammar.tokenizeLine "(q[TEST])"
    expect(tokens[1]).toEqual value : 'q', scopes : [ 'source.perl6fe', 'string.quoted.q.operator.perl6fe' ]
    expect(tokens[2]).toEqual value : '[', scopes : [ 'source.perl6fe', 'punctuation.definition.string.perl6fe' ]
    expect(tokens[3]).toEqual value : 'TEST', scopes : [ 'source.perl6fe', 'string.quoted.q.bracket.quote.perl6fe' ]
    
  it "Private methods highlight properly. Issue 7", ->
    {tokens} = grammar.tokenizeLine "method !wrap-decoder(Supply:D $bin-supply, $enc)"
    expect(tokens[0]).toEqual value : 'method', scopes : [ 'source.perl6fe', 'storage.type.declarator.type.perl6fe' ] 
    expect(tokens[2]).toEqual value : '!', scopes : [ 'source.perl6fe', 'support.class.method.private.perl6fe' ] 
    expect(tokens[3]).toEqual value : 'wrap-decoder', scopes : [ 'source.perl6fe', 'entity.name.function.perl6fe' ]

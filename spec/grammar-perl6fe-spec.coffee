describe "Perl 6 FE grammar", ->
  grammar = null

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
  it "=begin pod works", ->
    line = " =begin pod"
    expect(grammar.firstLineRegex.scanner.findNextMatchSync(line)).not.toBeNull()

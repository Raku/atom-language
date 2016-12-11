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

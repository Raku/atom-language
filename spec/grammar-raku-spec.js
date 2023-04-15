describe("Raku grammar", function() {
  let grammar = null;
  let grammarRE = null;
  beforeEach(function() {
    waitsForPromise(function() {
      return atom.packages.activatePackage("language-perl6");
    });
    return runs(function() {
      grammar = atom.grammars.grammarForScopeName("source.raku");
      return grammarRE = atom.grammars.grammarForScopeName("source.regexp.raku");
    });
  });
  
  // Sanity checks
  it("parses source.raku", function() {
    expect(grammar).toBeDefined();
    return expect(grammar.scopeName).toBe("source.raku");
  });
  
  it("parses source.regexp.raku", function() {
    expect(grammarRE).toBeDefined();
    return expect(grammarRE.scopeName).toBe("source.regexp.raku");
  });
  
  // First line language detection
  it("use v6 works", function() {
    const lne = " use v6;";
    return expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull();
  });

  it("First line: =comment detected as Raku", function() {
    const lne = " =comment detected as Raku";
    return expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull();
  });

  it(" =begin pod works", function() {
    const lne = " =begin pod";
    return expect(grammar.firstLineRegex.scanner.findNextMatchSync(lne)).not.toBeNull();
  });
  
  // Types
  it("Same highlights as a type", function() {
    const {tokens} = grammar.tokenizeLine('Same');
    return expect(tokens[0]).toEqual({
      value: 'Same',
      scopes: ['source.raku', 'support.type.raku']
    });
  });
  
  
  // Bugs
  // $line.match(/^\s*$/)
  it("s:g[] with adverbs highlight properly №69", function() {
    const {tokens} = grammar.tokenizeLine("s:g[^testing$] ^");
    expect(tokens[3]).toEqual({
      value: '^',
      scopes: ['source.raku', 'string.regexp.bracket.raku', 'entity.name.section.boundary.regexp.raku']
    });
    return expect(tokens[7]).toEqual({
      value: ' ',
      scopes: ['source.raku']
    });
  });
  
  it("identifiers with embedded dash/apostroph highlight properly № 83", function() {
    const {tokens} = grammar.tokenizeLine("$var-var-123 \"@var\'var-123\"");
    expect(tokens[1]).toEqual({
      value: 'var-var',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.raku']
    });
    return expect(tokens[5]).toEqual({
      value: "var\'var",
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku']
    });
  });
  
  it("when before bare regex highlights properly", function() {
    const {tokens} = grammar.tokenizeLine("when / ^ /");
    return expect(tokens[2]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
  });
  
  it("bracket regex with s: highlights properly № 60", function() {
    const {tokens} = grammar.tokenizeLine("s:g { [^ | <?after '\\\\'>] <!before '..\\\\'> <-[\\\\]>+ '\\\\..' ['\\\\' | $ ] } = '' { };");
    expect(tokens[1]).toEqual({
      value: ':g',
      scopes: ['source.raku', 'entity.name.section.adverb.regexp.raku']
    });
    expect(tokens[3]).toEqual({
      value: '{',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
    return expect(tokens[5]).toEqual({
      value: '^',
      scopes: ['source.raku', 'fstring.regexp.raku', 'entity.name.section.boundary.regexp.raku']
    });
  });
  
  it("bracket before number does not accidently highlight as a number № 58", function() {
    const {tokens} = grammar.tokenizeLine("{1}");
    return expect(tokens[1]).toEqual({
      value: '1',
      scopes: ['source.raku', 'meta.block.raku', 'constant.numeric.raku']
    });
  });
  
  it(":= assignment highlights as one token and correctly", function() {
    const {tokens} = grammar.tokenizeLine("10 := 11");
    return expect(tokens[2]).toEqual({
      value: ':=',
      scopes: ['source.raku', 'storage.modifier.assignment.raku']
    });
  });
  
  it("single quotes in regex don't break", function() {
    const {tokens} = grammar.tokenizeLine("/ '/' /");
    expect(tokens[0]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
    expect(tokens[2]).toEqual({
      value: "'",
      scopes: ['source.raku', 'string.regexp.raku', 'string.literal.raku']
    });
    return expect(tokens[5]).toEqual({
      value: ' /',
      scopes: ['source.raku', 'string.quoted.single.single.raku']
    });
  });
  
  it("m:i{blah} highlights as regex", function() {
    const {tokens} = grammar.tokenizeLine("m:i{ blah }");
    return expect(tokens[2]).toEqual({
      value: '{',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
  });
  
  it("^-10 highlights as a number", function() {
    const {tokens} = grammar.tokenizeLine("^-10");
    return expect(tokens[0]).toEqual({
      value: '^-10',
      scopes: ['source.raku', 'constant.numeric.raku']
    });
  });
  
  it("Regex using .match highlights $line.match(/^\\s*$/)", function() {
    const {tokens} = grammar.tokenizeLine('$line.match(/^\\s*$/)');
    expect(tokens[3]).toEqual({
      value: 'match',
      scopes: ['source.raku', 'support.function.raku']
    });
    return expect(tokens[5]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
  });
  
  it("Bare Regex with ~~ before it highlights", function() {
    const {tokens} = grammar.tokenizeLine('"t" ~~ /^\\s$/');
    return expect(tokens[6]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
  });
  
  it("proto method does not highlight properly. Issue № 31", function() {
    const {tokens} = grammar.tokenizeLine('proto method rename(|) { * }');
    expect(tokens[0]).toEqual({
      value: 'proto',
      scopes: ['source.raku', 'storage.type.declarator.multi.raku']
    });
    expect(tokens[2]).toEqual({
      value: 'method',
      scopes: ['source.raku', 'storage.type.declarator.type.raku']
    });
    return expect(tokens[4]).toEqual({
      value: 'rename',
      scopes: ['source.raku', 'entity.name.function.raku']
    });
  });

  it("Putting spaces around / division operator highlights properly. Issue № 34", function() {
    const {tokens} = grammar.tokenizeLine('isa-ok(1 / 4, Rat, "/ makes a Rat");');
    return expect(tokens[4]).toEqual({
      value: '/',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
  });

  it("Two variables in a row don't allow hyphens in variable name. Issue № 40", function() {
    const {tokens} = grammar.tokenizeLine('$reverse-solidus$reverse-solidus');
    return expect(tokens[3]).toEqual({
      value: 'reverse-solidus',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.raku']
    });
  });

  it("Keywords that are flow control highlight as methods when used as methods. Issue № 35", function() {
    const {tokens} = grammar.tokenizeLine('$p2.break');
    return expect(tokens[3]).toEqual({
      value: 'break',
      scopes: ['source.raku', 'support.function.raku']
    });
  });

  it("1e-6 highlights as a number. Issue № 35", function() {
    const {tokens} = grammar.tokenizeLine('1e-6');
    return expect(tokens[0]).toEqual({
      value: '1e-6',
      scopes: ['source.raku', 'constant.numeric.raku']
    });
  });

  it("Issue № 36. Variables highlight correctly if they contain any non-ASCII characters ", function() {
    const {tokens} = grammar.tokenizeLine('$ΔxAB');
    expect(tokens[0]).toEqual({
      value: '$',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.sigil.raku']
    });
    return expect(tokens[1]).toEqual({
      value: 'ΔxAB',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.raku']
    });
  });

  it("Issue № 39. Angle bracket quoting needlessly starts", function() {
    const {tokens} = grammar.tokenizeLine('$i++ < 3; # >');
    expect(tokens[0]).toEqual({
      value: '$',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.sigil.raku']
    });
    expect(tokens[1]).toEqual({
      value: 'i',
      scopes: ['source.raku', 'meta.variable.container.raku', 'variable.other.identifier.raku']
    });
    expect(tokens[4]).toEqual({
      value: '<',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
    return expect(tokens[8]).toEqual({
      value: '#',
      scopes: ['source.raku', 'comment.line.number-sign.raku', 'punctuation.definition.comment.raku']
    });
  });

  it("Issue №38 array word quoting doesn't end when \\\\ seen at end", function() {
    const {tokens} = grammar.tokenizeLine('< \\\\>');
    expect(tokens[0]).toEqual({
      value: '<',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
    return expect(tokens[3]).toEqual({
      value: '>',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
  });

  it("m/\\\\/ regex highlights with two backslash in it", function() {
    const {tokens} = grammar.tokenizeLine('m/\\\\/');
    expect(tokens[0]).toEqual({
      value: 'm',
      scopes: ['source.raku', 'string.regexp.construct.slash.raku']
    });
    expect(tokens[1]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.slash.raku']
    });
    expect(tokens[2]).toEqual({
      value: '\\\\',
      scopes: ['source.raku', 'string.regexp.slash.raku']
    });
    return expect(tokens[3]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.slash.raku']
    });
  });

  it("# regex highlights arbitrary delimiters when using m", function() {
    const {tokens} = grammar.tokenizeLine('say m|hi|');
    return {tokens};
  });

  it("doesn't start regex for routines with regex in them", function() {
    const {tokens} = grammar.tokenizeLine('regex_coderef');
    return expect(tokens[0]).toEqual({
      value: 'regex_coderef',
      scopes: ['source.raku', 'routine.name.raku']
    });
  });

  it("Regex doesn't start with just a /", function() {
    const {tokens} = grammar.tokenizeLine('/');
    return expect(tokens[0]).toEqual({
      value: '/',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
  });
  
  // Pod
  it("Pod headers highlight until newline", function() {
    const lines = grammar.tokenizeLines('=head1 abc\nethethe head\n\ntrim');
    expect(lines[0][0]).toEqual({
      value: '=',
      scopes: ['source.raku', 'storage.modifier.block.abbreviated.raku']
    });
    expect(lines[0][1]).toEqual({
      value: 'head1',
      scopes: ['source.raku', 'entity.other.attribute-name.block.abbreviated.raku']
    });
    return expect(lines[1][0]).toEqual({
      value: 'ethethe head',
      scopes: ['source.raku', 'entity.name.section.head.abbreviated.raku']
    });
  });

  // Methods
  it("multi sub highlights properly. Issue №26", function() {
    const {tokens} = grammar.tokenizeLine("multi sub thingy");
    expect(tokens[0]).toEqual({
      value: 'multi',
      scopes: ['source.raku', 'storage.type.declarator.multi.raku']
    });
    expect(tokens[1]).toEqual({
      value: ' ',
      scopes: ['source.raku']
    });
    expect(tokens[2]).toEqual({
      value: 'sub',
      scopes: ['source.raku', 'storage.type.declarator.type.raku']
    });
    expect(tokens[3]).toEqual({
      value: ' ',
      scopes: ['source.raku']
    });
    return expect(tokens[4]).toEqual({
      value: 'thingy',
      scopes: ['source.raku', 'entity.name.function.raku']
    });
  });

  it("FQ private methods are highlighted properly Issue №8", function() {
    const {tokens} = grammar.tokenizeLine("self.List::perl;");
    expect(tokens[0]).toEqual({
      value: 'self',
      scopes: ['source.raku', 'variable.language.raku']
    });
    expect(tokens[1]).toEqual({
      value: '.',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
    expect(tokens[2]).toEqual({
      value: 'List',
      scopes: ['source.raku', 'support.type.raku']
    });
    expect(tokens[3]).toEqual({
      value: '::',
      scopes: ['source.raku', 'support.function.raku', 'keyword.operator.colon.raku']
    });
    return expect(tokens[4]).toEqual({
      value: 'perl',
      scopes: ['source.raku', 'support.function.raku']
    });
  });

  it("self.perl highlights", function() {
    const {tokens} = grammar.tokenizeLine("self.perl");
    expect(tokens[0]).toEqual({
      value: 'self',
      scopes: ['source.raku', 'variable.language.raku']
    });
    expect(tokens[1]).toEqual({
      value: '.',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
    return expect(tokens[2]).toEqual({
      value: 'perl',
      scopes: ['source.raku', 'support.function.raku']
    });
  });

  it("Private methods highlight properly. Issue №7", function() {
    const {tokens} = grammar.tokenizeLine("method !wrap-decoder(Supply:D $bin-supply, $enc)");
    expect(tokens[0]).toEqual({
      value: 'method',
      scopes: ['source.raku', 'storage.type.declarator.type.raku']
    });
    expect(tokens[2]).toEqual({
      value: '!',
      scopes: ['source.raku', 'support.class.method.private.raku']
    });
    return expect(tokens[3]).toEqual({
      value: 'wrap-decoder',
      scopes: ['source.raku', 'entity.name.function.raku']
    });
  });

  // Operators
  it("Hex numbers highlight properly with dash-minus in front", function() {
    const {tokens} = grammar.tokenizeLine("-0x10");
    return expect(tokens[0]).toEqual({
      value: '-0x10',
      scopes: ['source.raku', 'constant.numeric.radix.raku']
    });
  });

  it("Hex numbers highlight properly with plus sign in front", function() {
    const {tokens} = grammar.tokenizeLine("+0x10");
    return expect(tokens[0]).toEqual({
      value: '+0x10',
      scopes: ['source.raku', 'constant.numeric.radix.raku']
    });
  });

  it("Hex numbers highlight properly with minus sign U2212 in front", function() {
    const {tokens} = grammar.tokenizeLine("−0x10");
    return expect(tokens[0]).toEqual({
      value: '−0x10',
      scopes: ['source.raku', 'constant.numeric.radix.raku']
    });
  });

  it("Numbers highlight properly with minus sign U2212 in front", function() {
    const {tokens} = grammar.tokenizeLine("−42");
    return expect(tokens[0]).toEqual({
      value: '−42',
      scopes: ['source.raku', 'constant.numeric.raku']
    });
  });

  it("Numbers highlight properly with no whole number and a sign", function() {
    const {tokens} = grammar.tokenizeLine("−.42");
    return expect(tokens[0]).toEqual({
      value: '−.42',
      scopes: ['source.raku', 'constant.numeric.raku']
    });
  });

  it("=~= approximately-equal to operator highlights properly", function() {
    const {tokens} = grammar.tokenizeLine("=~=");
    return expect(tokens[0]).toEqual({
      value: "=~=",
      scopes: ['source.raku', 'meta.operator.non.ligature.raku', 'keyword.operator.approx-equal.raku']
    });
  });

  it("≅ approximately-equal to operator highlights properly", function() {
    const {tokens} = grammar.tokenizeLine("≅");
    return expect(tokens[0]).toEqual({
      value: "≅",
      scopes: ['source.raku', 'meta.operator.non.ligature.raku', 'keyword.operator.approx-equal.raku']
    });
  });

  // Comments
  it("Multi-line comments with paren start", function() {
    const {tokens} = grammar.tokenizeLine("#`(");
    return expect(tokens[0]).toEqual({
      value: '#`(',
      scopes: ['source.raku', 'comment.multiline.hash-tick.paren.raku']
    });
  });

  // Quoting {qq[ ]}
  it("qq quoting works if surrounded by curly brackets", function() {
    const {tokens} = grammar.tokenizeLine("{qq[ ]}");
    return expect(tokens[1]).toEqual({
      value: 'qq',
      scopes: ['source.raku', 'meta.block.raku', 'string.quoted.qq.operator.raku']
    });
  });

  it("qq quoting works if surrounded by parens", function() {
    const {tokens} = grammar.tokenizeLine("(qq[ ])");
    return expect(tokens[1]).toEqual({
      value: 'qq',
      scopes: ['source.raku', 'string.quoted.qq.operator.raku']
    });
  });

  it("Function calls in interpolated strings don't overrun the line", function() {
    const {tokens} = grammar.tokenizeLine('"$o.n()".s( ) ]);');
    expect(tokens[4]).toEqual({
      value: 'n',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku', 'support.function.raku']
    });
    expect(tokens[5]).toEqual({
      value: '()',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku']
    });
    return expect(tokens[7]).toEqual({
      value: '.',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
  });

  it("Function calls highlight in interpolated strings", function() {
    const {tokens} = grammar.tokenizeLine('"$b.foo() should)"');
    expect(tokens[1]).toEqual({
      value: '$',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku', 'variable.other.identifier.sigil.raku']
    });
    expect(tokens[2]).toEqual({
      value: 'b',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku']
    });
    expect(tokens[3]).toEqual({
      value: '.',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku', 'keyword.operator.dot.raku']
    });
    expect(tokens[4]).toEqual({
      value: 'foo',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku', 'support.function.raku']
    });
    expect(tokens[5]).toEqual({
      value: '()',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku']
    });
    return expect(tokens[6]).toEqual({
      value: ' should)',
      scopes: ['source.raku', 'string.quoted.double.raku']
    });
  });

  it("Variables highlight in interpolated strings", function() {
    const {tokens} = grammar.tokenizeLine('"$var"');
    expect(tokens[0]).toEqual({
      value: '"',
      scopes: ['source.raku', 'string.quoted.double.raku', 'punctuation.definition.string.begin.raku']
    });
    expect(tokens[1]).toEqual({
      value: '$',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku', 'variable.other.identifier.sigil.raku']
    });
    return expect(tokens[2]).toEqual({
      value: 'var',
      scopes: ['source.raku', 'string.quoted.double.raku', 'variable.other.identifier.interpolated.raku']
    });
  });

  it("Angle bracket word quoting works multi-line, when after = sign", function() {
    const lines = grammar.tokenizeLines("my $var = < a b\nc d >");
    return expect(lines[0][7]).toEqual({
      value: '<',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
  });

  it("Angle brackets don't quote for less than sign", function() {
    const {tokens} = grammar.tokenizeLine("while $i < $len");
    return expect(tokens[5]).toEqual({
      value: '<',
      scopes: ['source.raku', 'keyword.operator.generic.raku']
    });
  });

  it("Angle bracket quoting works", function() {
    const {tokens} = grammar.tokenizeLine("<test>");
    expect(tokens[0]).toEqual({
      value: '<',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
    expect(tokens[1]).toEqual({
      value: 'test',
      scopes: ['source.raku', 'string.array.words.raku']
    });
    return expect(tokens[2]).toEqual({
      value: '>',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
  });

  it("Angle bracket quoting works with } in them Issue №2", function() {
    const {tokens} = grammar.tokenizeLine("<test}>");
    expect(tokens[0]).toEqual({
      value: '<',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
    expect(tokens[1]).toEqual({
      value: 'test}',
      scopes: ['source.raku', 'string.array.words.raku']
    });
    return expect(tokens[2]).toEqual({
      value: '>',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
  });

  it("q[TEST] works", function() {
    const {tokens} = grammar.tokenizeLine("q[TEST]");
    expect(tokens[0]).toEqual({
      value: 'q',
      scopes: ['source.raku', 'string.quoted.q.operator.raku']
    });
    expect(tokens[1]).toEqual({
      value: '[',
      scopes: ['source.raku', 'punctuation.definition.string.raku']
    });
    return expect(tokens[2]).toEqual({
      value: 'TEST',
      scopes: ['source.raku', 'string.quoted.q.bracket.quote.raku']
    });
  });

  it("q[] works surrounded by parenthesis", function() {
    const {tokens} = grammar.tokenizeLine("(q[TEST])");
    expect(tokens[1]).toEqual({
      value: 'q',
      scopes: ['source.raku', 'string.quoted.q.operator.raku']
    });
    expect(tokens[2]).toEqual({
      value: '[',
      scopes: ['source.raku', 'punctuation.definition.string.raku']
    });
    expect(tokens[3]).toEqual;
    return {
      value: 'TEST',
      scopes: ['source.raku', 'string.quoted.q.bracket.quote.raku']
    };
  });

  it("Escaped variables don't syntax highlight in double quotation marks", function() {
    const {tokens} = grammar.tokenizeLine("method !wrap-decoder(Supply:D $bin-supply, $enc)");
    expect(tokens[0]).toEqual({
      value: 'method',
      scopes: ['source.raku', 'storage.type.declarator.type.raku']
    });
    expect(tokens[2]).toEqual({
      value: '!',
      scopes: ['source.raku', 'support.class.method.private.raku']
    });
    return expect(tokens[3]).toEqual({
      value: 'wrap-decoder',
      scopes: ['source.raku', 'entity.name.function.raku']
    });
  });

  // Pairs
  it("Pairs highlight when no quotes used for key", function() {
    const {tokens} = grammar.tokenizeLine("NFKD_QC=>'NFKD_Quick_Check', Ext=>'Extender'");
    expect(tokens[0]).toEqual({
      value: 'NFKD_QC',
      scopes: ['source.raku', 'string.pair.key.raku']
    });
    expect(tokens[1]).toEqual({
      value: '=>',
      scopes: ['source.raku', 'keyword.operator.multi-symbol.raku']
    });
    expect(tokens[2]).toEqual({
      value: '\'',
      scopes: ['source.raku', 'string.quoted.single.single.raku', 'punctuation.definition.string.begin.raku']
    });
    expect(tokens[3]).toEqual({
      value: 'NFKD_Quick_Check',
      scopes: ['source.raku', 'string.quoted.single.single.raku']
    });
    expect(tokens[4]).toEqual({
      value: "'",
      scopes: ['source.raku', 'string.quoted.single.single.raku', 'punctuation.definition.string.end.raku']
    });
    expect(tokens[5]).toEqual({
      value: ', ',
      scopes: ['source.raku']
    });
    expect(tokens[6]).toEqual({
      value: 'Ext',
      scopes: ['source.raku', 'string.pair.key.raku']
    });
    return expect(tokens[7]).toEqual({
      value: '=>',
      scopes: ['source.raku', 'keyword.operator.multi-symbol.raku']
    });
  });

  it("Pairs highlight when no quotes used for key and no spaces", function() {
    const {tokens} = grammar.tokenizeLine("NFKD_QC=>'NFKD_Quick_Check',Ext=>'Extender'");
    expect(tokens[0]).toEqual({
      value: 'NFKD_QC',
      scopes: ['source.raku', 'string.pair.key.raku']
    });
    expect(tokens[1]).toEqual({
      value: '=>',
      scopes: ['source.raku', 'keyword.operator.multi-symbol.raku']
    });
    expect(tokens[2]).toEqual({
      value: '\'',
      scopes: ['source.raku', 'string.quoted.single.single.raku', 'punctuation.definition.string.begin.raku']
    });
    expect(tokens[3]).toEqual({
      value: 'NFKD_Quick_Check',
      scopes: ['source.raku', 'string.quoted.single.single.raku']
    });
    expect(tokens[4]).toEqual({
      value: "'",
      scopes: ['source.raku', 'string.quoted.single.single.raku', 'punctuation.definition.string.end.raku']
    });
    expect(tokens[5]).toEqual({
      value: ',',
      scopes: ['source.raku']
    });
    expect(tokens[6]).toEqual({
      value: 'Ext',
      scopes: ['source.raku', 'string.pair.key.raku']
    });
    return expect(tokens[7]).toEqual({
      value: '=>',
      scopes: ['source.raku', 'keyword.operator.multi-symbol.raku']
    });
  });

  // Variables
  it("Method made highlights", function() {
    const {tokens} = grammar.tokenizeLine("Calculator.made");
    return expect(tokens[2]).toEqual({
      value: 'made',
      scopes: ['source.raku', 'keyword.control.flowcontrol.regex.raku']
    });
  });

  it("Regex named captures highlight", function() {
    const {tokens} = grammar.tokenizeLine("$<captured>");
    expect(tokens[0]).toEqual({
      value: '$',
      scopes: ['source.raku', 'meta.match.variable.raku', 'variable.other.identifier.sigil.regexp.perl6']
    });
    expect(tokens[1]).toEqual({
      value: '<',
      scopes: ['source.raku', 'meta.match.variable.raku', 'support.class.match.name.delimiter.regexp.raku']
    });
    expect(tokens[2]).toEqual({
      value: 'captured',
      scopes: ['source.raku', 'meta.match.variable.raku', 'variable.other.identifier.regexp.perl6']
    });
    return expect(tokens[3]).toEqual({
      value: '>',
      scopes: ['source.raku', 'meta.match.variable.raku', 'support.class.match.name.delimiter.regexp.raku']
    });
  });

  it("regex rule calc-op:sym<add> highlights.", function() {
    const {tokens} = grammar.tokenizeLine('rule calc-op:sym<add>');
    expect(tokens[3]).toEqual({
      value: ':',
      scopes: ['source.raku', 'meta.regexp.named.raku', 'meta.regexp.named.adverb.raku', 'punctuation.definition.regexp.adverb.raku']
    });
    expect(tokens[4]).toEqual({
      value: 'sym',
      scopes: ['source.raku', 'meta.regexp.named.raku', 'meta.regexp.named.adverb.raku', 'support.type.class.adverb.raku']
    });
    expect(tokens[5]).toEqual({
      value: '<',
      scopes: ['source.raku', 'meta.regexp.named.raku']
    });
    return expect(tokens[6]).toEqual({
      value: 'add',
      scopes: ['source.raku', 'meta.regexp.named.raku', 'string.array.words.raku']
    });
  });

  it("regex grammar method ops highlight. Issue №12", function() {
    const {tokens} = grammar.tokenizeLine('method calc-op:sym<add>');
    expect(tokens[3]).toEqual({
      value: ':',
      scopes: ['source.raku', 'punctuation.definition.function.adverb.raku']
    });
    expect(tokens[4]).toEqual({
      value: 'sym',
      scopes: ['source.raku', 'support.type.class.adverb.raku']
    });
    expect(tokens[5]).toEqual({
      value: '<',
      scopes: ['source.raku', 'span.keyword.operator.array.words.raku']
    });
    return expect(tokens[6]).toEqual({
      value: 'add',
      scopes: ['source.raku', 'string.array.words.raku']
    });
  });

  it("Regex named captures highlight in double quoted strings. Issue №9", function() {
    const {tokens} = grammar.tokenizeLine('"$<captured>"');
    expect(tokens[0]).toEqual({
      value: '"',
      scopes: ['source.raku', 'string.quoted.double.raku', 'punctuation.definition.string.begin.raku']
    });
    expect(tokens[1]).toEqual({
      value: '$',
      scopes: ['source.raku', 'string.quoted.double.raku', 'meta.match.variable.raku', 'variable.other.identifier.sigil.regexp.perl6']
    });
    expect(tokens[2]).toEqual({
      value: '<',
      scopes: ['source.raku', 'string.quoted.double.raku', 'meta.match.variable.raku', 'support.class.match.name.delimiter.regexp.raku']
    });
    expect(tokens[3]).toEqual({
      value: 'captured',
      scopes: ['source.raku', 'string.quoted.double.raku', 'meta.match.variable.raku', 'variable.other.identifier.regexp.perl6']
    });
    return expect(tokens[4]).toEqual({
      value: '>',
      scopes: ['source.raku', 'string.quoted.double.raku', 'meta.match.variable.raku', 'support.class.match.name.delimiter.regexp.raku']
    });
  });

  // Regex
  it("Hyphens and ' are allowed in grammar rules", function() {
    const {tokens} = grammar.tokenizeLine("rule calc's-op");
    expect(tokens[0]).toEqual({
      value: 'rule',
      scopes: ['source.raku', 'meta.regexp.named.raku', 'storage.type.declare.regexp.named.raku']
    });
    return expect(tokens[2]).toEqual({
      value: "calc's-op",
      scopes: ['source.raku', 'meta.regexp.named.raku', 'entity.name.function.regexp.named.raku']
    });
  });
// ##The line below is fudged due to an Atom bug that only shows up when testing
//intermittently. Please unfudge and test before release.  
  it("Regex hex highlights in character classes Issue №10. Atom Issue #5025", function() {
    const {tokens} = grammar.tokenizeLine('/<[ \\x[99] ]>/');
    expect(tokens[0]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
    expect(tokens[1]).toEqual({
      value: '<',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'punctuation.delimiter.property.regexp.raku']
    });
    expect(tokens[2]).toEqual({
      value: '[',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'keyword.operator.charclass.open.regexp.raku']
    });
    expect(tokens[3]).toEqual({
      value: ' ',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku']
    });
    expect(tokens[4]).toEqual({
      value: '\\x',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku', 'punctuation.hex.raku', 'keyword.punctuation.hex.raku']
    });
    expect(tokens[5]).toEqual({
      value: '[',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku', 'punctuation.hex.raku', 'keyword.operator.bracket.open.raku']
    });
    expect(tokens[6]).toEqual({
      value: '99',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku', 'punctuation.hex.raku', 'routine.name.hex.raku']
    });
    expect(tokens[7]).toEqual({
      value: ']',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku', 'punctuation.hex.raku', 'keyword.operator.bracket.close.raku']
    });
    expect(tokens[8]).toEqual({
      value: ' ',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'constant.character.custom.property.regexp.raku']
    });
    expect(tokens[9]).toEqual({
      value: ']',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'keyword.operator.charclass.close.regexp.raku']
    });
    expect(tokens[10]).toEqual({
      value: '>',
      scopes: ['source.raku', 'string.regexp.raku', 'meta.property.regexp.raku', 'punctuation.delimiter.property.regexp.raku']
    });
    return expect(tokens[11]).toEqual({
      value: '/',
      scopes: ['source.raku', 'punctuation.definition.regexp.raku']
    });
  });
});

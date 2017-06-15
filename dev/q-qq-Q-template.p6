#!/usr/bin/env perl6
# Generate the q[] qq[] and Q[] quoting constructs
my @open-close-delimiters =
#Left Pi right Pf. Open Ps close Pe
# std prop: What quoting style does it use by default?
# For example “…” quoting is like qq, while '…' is like q
#name                       #open        #close      #number #std quotes #std prop. #pod-tag?
('triple_paren',          Q<\\(\\(\\(>, Q<\\)\\)\\)>, 3,       False,   True),
('triple_bracket',        Q<\\[\\[\\[>, Q<\\]\\]\\]>, 3,       False),
('triple_brace',          Q<\\{\\{\\{>, Q<\\}\\}\\}>, 3,       False),
('triple_angle',             '<<<',      '>>>',       3,       False,  Nil,        True),
('double_angle',            '<<',        '>>',        2,       False,  Nil,        True),
('double_paren',             Q<\\(\\(>,   Q<\\)\\)>,  2,       False),
('double_bracket',           Q<\\[\\[>,   Q<\\]\\]>,  2,       False),
('double_brace',            '{{',         Q<}}>,      2,       False),
('brace',                   '{',          Q<}>,       1,       False),
('angle',                   '<',         '>',         1,       False,  Nil,        True),
('paren',                    Q<\\(>,      Q<\\)>,     1,       False),
('bracket',                  Q<\\[>,      Q<\\]>,     1,       False),
('left_double_right_double', Q<“>,        Q<”>,       1,       True,    'qq'),
('left_double-low-q_right_double', '„', '”|“',          1,      True,    'qq'),
('left_single_right_single', Q<‘>,        Q<’>,       1,       True,    'q'),
('low-q_left_single', Q<‚>,        Q<‘>,       1,       True,    'q'),
('fw_cornerbracket',         Q<「>,       Q<」>,      1,        False),
('hw_cornerbracket',         Q<｢>,        Q<｣>,       1,       False),
('chevron',                   '«',         '»',       1,       False,  Nil,       True),
('s-shaped-bag-delimiter',     '⟅',       '⟆',         1,       False),
;
my $DEBUG = False;
my @delimiters = @open-close-delimiters;
=comment unmatched delimiters
the delimiters being pushed to @delimiters are unmatched (open and close delimiters are the same)

push @delimiters, ('slash',  '/',   '/',   1, False);
push @delimiters, ('single', Q<\'>, Q<\'>, 1, True, 'q');
push @delimiters, ('double', Q<">,  Q<">,  1, True, 'qq');
push @delimiters, ('right_double_right_double', '”', '”', 1, True, 'qq');
# These identifiers are not allowed to be used without a space.
# Example: q '…'
my @identifiers = '-', Q[\'];

## Replace XXX with the content's name
## Replace YYY with the escaped opening delimiter
## Replace ZZZ with the escaped closing delimiter
my $qq-quotation-marks = Q:to/🐧/;
# Quotation Mark XXX
  {
    'begin': 'YYY'
    'beginCaptures':
      '0': 'name': 'punctuation.definition.string.begin.perl6fe'
    'end': 'ZZZ'
    'endCaptures':
      '0': 'name': 'punctuation.definition.string.end.perl6fe'
    'name': 'string.quoted.XXX.perl6fe'
    'patterns': [
      {
        'match': '\\\\[YYYZZZabtnfre\\\\\\{\\}]'
        'name': 'constant.character.escape.perl6fe'
      }
      { 'include': '#interpolation' }
      { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
    ]
  }
🐧
my $q-quotation-marks = Q:to/🐧/;
  {
    'begin': '(?<=\\W|^)YYY'
    'beginCaptures':
      '0':
        'name': 'punctuation.definition.string.begin.perl6fe'
    'end': 'ZZZ'
    'endCaptures':
      '0':
        'name': 'punctuation.definition.string.end.perl6fe'
    'name': 'string.quoted.single.XXX.perl6fe'
    'patterns': [
      {
        'match': '\\\\[YYYZZZ\\\\]'
        'name': 'constant.character.escape.perl6fe'
      }
      { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
    ]
  }
🐧
=comment Q quoting

my $q-patterns = Q:to/🐧/;
  # Q_XXX
  {
    'begin': '(?x) (?<=^|[\\[\\]\\s\\(\\){},;])
      (Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1': 'name': 'string.quoted.q.operator.perl6fe'
      '2': 'name': 'support.function.quote.adverb.perl6fe'
      '3': 'name': 'punctuation.definition.string.perl6fe'
    'end': 'ZZZ'
    'endCaptures':
      '0': 'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.q.XXX.quote.perl6fe'
    'patterns': [ { 'include': '#q_XXX_string_content' } ]
  }
  # q_XXX
  {
    'begin': '(?x) (?<=^|[\\[\\]\\s\\(\\){},;])
      (q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1': 'name': 'string.quoted.q.operator.perl6fe'
      '2': 'name': 'support.function.quote.adverb.perl6fe'
      '3': 'name': 'punctuation.definition.string.perl6fe'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'endCaptures':
      '0': 'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.q.XXX.quote.perl6fe'
    'patterns': [
      {
        'match': '\\\\YYY|\\\\ZZZ'
        'name': 'constant.character.escape.perl6fe'
      }
      { 'include': '#q_XXX_string_content' }
    ]
  }
  # qq_XXX
  {
    'begin': '(?x) (?<=^|[\\[\\]\\s\\(\\){},;])
      (qq(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1': 'name': 'string.quoted.qq.operator.perl6fe'
      '2': 'name': 'support.function.quote.adverb.perl6fe'
      '3': 'name': 'punctuation.definition.string.perl6fe'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'endCaptures':
      '0': 'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.qq.XXX.quote.perl6fe'
    'patterns': [
      {
        'match': '\\\\YYY|\\\\ZZZ'
        'name': 'constant.character.escape.perl6fe'
      }
      { 'include': '#qq_character_escape' }
      { 'include': 'source.perl6fe#interpolation' }
      { 'include': '#q_XXX_string_content' }
    ]
  }
🐧

##sections
my $q-second-str = Q:to/🐧/;
  # q_XXX
  'q_XXX_string_content':
    'begin': 'YYY'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'patterns': [ { 'include': '#q_XXX_string_content' } ]
🐧

my $q-any-str = Q:to/🐧/;
    # q_any qq_any Q_any
    {
    'begin': '(?x) (?<=^|[\\[\\]\\s\\(\\){},;])
      (q|qq|Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \\s*([^\\p{Ps}\\p{Pe}\\p{Pi}\\p{Pf}\\w\\s])'
    'beginCaptures':
      '1': 'name': 'string.quoted.q.operator.perl6fe'
      '2': 'name': 'support.function.quote.adverb.perl6fe'
      '3': 'name': 'punctuation.definition.string.perl6fe'
    'end': '\\3'
    'endCaptures':
      '0': 'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.q.any.quote.perl6fe'
    }
🐧

my $multiline-comment-str = Q:to/🐧/;
  # multiline comment XXX
  {
  'begin': '\\s*#`YYY',
  'end': 'ZZZ',
  'name': 'comment.multiline.hash-tick.XXX.perl6fe'
  'patterns': [
    {
      'begin': 'YYY'
      'end': 'ZZZ'
      'name': 'comment.internal.XXX.perl6fe'
    }
  ]
  }
🐧

my $pod-tag-str = Q:to/🐧/;
      # UYYY ZZZ
      {
        'begin': '(?x) (U) (YYY)'
        'beginCaptures':
          '1': 'name': 'support.function.pod.code.perl6fe'
          '2': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'end':   '(?x) (ZZZ)'
        'endCaptures':
          '1': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'contentName': 'markup.underline.perl6fe'
        'name': 'meta.pod.c.perl6fe'
        'patterns': [
          { 'include': '#comment-block-syntax' }
          { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
        ]
      }
      # IYYY ZZZ
      {
        'begin': '(?x) (I) (YYY)'
        'beginCaptures':
          '1': 'name': 'support.function.pod.code.perl6fe'
          '2': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'end':   '(?x) (ZZZ)'
        'endCaptures':
          '1': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'contentName': 'markup.italic.perl6fe'
        'name': 'meta.pod.c.perl6fe'
        'patterns': [
          { 'include': '#comment-block-syntax' }
          { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
        ]
      }
      # BYYY ZZZ
      {
        'begin': '(?x) (B) (YYY)'
        'beginCaptures':
          '1': 'name': 'support.function.pod.code.perl6fe'
          '2': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'end':   '(?x) (ZZZ)'
        'endCaptures':
          '1': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'contentName': 'markup.bold.perl6fe'
        'name': 'meta.pod.c.perl6fe'
        'patterns': [
          { 'include': '#comment-block-syntax' }
          { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
        ]
      }
      # UppercaseYYY ZZZ
      {
        'begin': '(?x) ([A-Z]) (YYY)'
        'beginCaptures':
          '1': 'name': 'support.function.pod.code.perl6fe'
          '2': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'end':   '(?x) (ZZZ)'
        'endCaptures':
          '1': 'name': 'punctuation.section.embedded.pod.code.perl6fe'
        'contentName': 'markup.raw.code.perl6fe'
        'name': 'meta.pod.c.perl6fe'
        'patterns': [
          { 'include': '#comment-block-syntax' }
          { 'include': 'source.quoting.perl6fe#q_XXX_string_content' }
        ]
      }
🐧
my $regex-tag-str = Q:to/♥/;
# regex_XXX
{
  'begin': '''(?x)
  (?<= ^|\\s )
  (?:
    (m|rx|s|S)
    (
      (?:
        (?<!:P5) # < This can maybe be removed because we
        \\s*:\\w+
        (?!\\s*:P5) # < include p5_regex above it
      )*
    )
  )
  \\s*
  (YYY)
  '''
  'beginCaptures':
    '1': 'name': 'string.regexp.construct.XXX.perl6fe'
    '2': 'name': 'entity.name.section.adverb.regexp.XXX.perl6fe'
    '3': 'name': 'punctuation.definition.regexp.XXX.perl6fe'
  'end': '(?x) (?: (?<!\\\\)|(?<=\\\\\\\\) ) (ZZZ)'
  'endCaptures':
    '1': 'name': 'punctuation.definition.regexp.XXX.perl6fe'
  'contentName': 'string.regexp.XXX.perl6fe'
  'patterns': [
    { 'include': '#interpolation' }
    { 'include': 'source.regexp.perl6fe' }
  ]
}
♥
sub regex-highlighting {
  my Str @output;
  @output.push: replace($regex-tag-str, |@delimiters.first({.[0] eq 'slash'}).head(3));
  for ^@open-close-delimiters -> $i {
    next unless @open-close-delimiters[$i][3] == 1;
    @output.push: replace($regex-tag-str, |@open-close-delimiters[$i].head(3));
  }
  @output.push: replace($regex-tag-str,
    'any',
    Q‘[^#\\p{Ps}\\p{Pe}\\p{Pi}\\p{Pf}\\w\'\\-<>\\-\\]\\)\\}\\{]’,
    Q‘\\3’
  );
  @output.join.indent(2);
}
my Str:D $regex-file = regex-highlighting;
sub replace ( Str $string is copy, $name, $begin, $end ) {
  $string ~~ s:g/XXX/$name/;
  # Note: q (…) qq (…) Q (…) are only allowed with a space.
  # Note: q '…' qq '…' Q '…' are only allowed with a space.
  if ( any(@identifiers) eq $begin ) or ( $begin eq Q<\\(> and $end eq Q<\\)> ) {
    $string ~~ s:g/'\\\\s*(YYY)'/\\\\s+(YYY)/
  }
  if $begin eq $end {
    $string ~~ s:g/'\\\\\\\\YYY|\\\\\\\\ZZZ'/\\\\\\\\YYY/;
    $string ~~ s:g/YYYZZZ/YYY/;
  }
  $string ~~ s:g/YYY/$begin/;
  $string ~~ s:g/ZZZ/$end/;
  $string;
}
sub replace-multiline-comment ( Str $string is copy, $name, $begin, $end ) {
  $string ~~ s:g/XXX/$name/;
  $string ~~ s:g/YYY/$begin/;
  $string ~~ s:g/ZZZ/$end/;
  $string;
}
my $normal-quotes-file;
my $zero-file;
my $first-file;
my $second-file;
my $third-file;
for ^@delimiters -> $i {
  next unless @delimiters[$i][6];
  my ($name, $open, $close, $num, $nil, $Nil, $bool) = @delimiters[$i];
  $third-file ~= replace-multiline-comment($pod-tag-str, $name, $open, $close);
}
# Normal quotation marks
for ^@delimiters -> $i {
  next unless @delimiters[$i][4];
  my ($name, $open, $close, $num, $bool, $type) = @delimiters[$i];
  #say $type;
  #say $bool;
  given $type {
    when 'qq' { $normal-quotes-file ~= replace($qq-quotation-marks, $name, $open, $close) }
    when 'q'  { $normal-quotes-file ~= replace($q-quotation-marks, $name, $open, $close) }
    default { say "help"; }
  }
}
#$first-file ~= $normal-quotes-file;
# Multi line comment
for ^@open-close-delimiters -> $i {
    $zero-file ~= replace-multiline-comment $multiline-comment-str,
                          @open-close-delimiters[$i][0],
                          @open-close-delimiters[$i][1],
                          @open-close-delimiters[$i][2];
}
$zero-file ~= $normal-quotes-file;
# q qq Q quoting constructs
for ^@delimiters -> $i {
    if use-for-q @delimiters[$i] {
        #say "Skipping: {@delimiters[$i].perl}" unless $DEBUG;
        next;
    }
    $first-file ~= replace($q-patterns, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);

}
# Get list of symbols we shouldn't use for q_any (using whatever delimiter the person wants)
my @not-any;
for ^@delimiters -> $i {
    if @delimiters[$i][3] eq 1 {
        push @not-any, @delimiters[$i][1] if @delimiters[$i][3] eq 1;
        push @not-any, @delimiters[$i][2] if @delimiters[$i][1] ne @delimiters[$i][2];
    }
}
#push @not-any, '@';
@not-any .= unique;
#`{{ We now use unicode properties so don't have to create a list of all the delimiters
my $not-any = @not-any.join('');
$q-any-str ~~ s/ZZZ/$not-any/;
}}
$first-file ~= $q-any-str;

for ^@delimiters -> $i {
    if use-for-q @delimiters[$i] {
        #say "Skipping: {@delimiters[$i].perl}" unless $DEBUG;
        next;
    }
    $second-file ~= replace($q-second-str, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);
}
spurt 'ZERO.cson', $zero-file;
spurt 'FIRST.cson', $first-file;
spurt 'SECOND.cson', $second-file;
spurt 'THIRD.cson', $third-file;
spurt 'REGEX.cson', $regex-file;
say "Done generating.";
sub use-for-q ( @delimiters ) {
    # If the delimiters are equal and they are an opening, closing or begining or ending
    # unicode type symbol, then we can't use it for q/qq/Q
    @delimiters[1] eq @delimiters[2] and uniprop(@delimiters[1]) eq any('Pi', 'Pf', 'Ps', 'Pe');
}
# vim: ts=2

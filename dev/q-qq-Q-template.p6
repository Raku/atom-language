## Replace XXX with the content's name
## Replace YYY with the escaped opening delimiter
## Replace ZZZ with the escaped closing delimiter
my @delimiters =
#name                       #open        #close      #number
('double_angle',            '<<',        '>>',        2),
('double_paren',             Q<\\(\\(>,   Q<\\)\\)>,  2),
('double_bracket',           Q<\\[\\[>,   Q<\\]\\]>,  2),
('double_brace',            '{{',         Q<}}>,      2),
('brace',                   '{',          Q<}>,       1),
('angle',                   '<',         '>',         1),
('paren',                    Q<\\(>,      Q<\\)>,     1),
('bracket',                  Q<\\[>,      Q<\\]>,     1),
('double',                   Q<">,        Q<">,       1),
('single',                   Q<\'>,       Q<\'>,      1),
('slash',                    '/',        '/',         1),
('left_double_right_double', Q<“>,        Q<”>,       1),
('left_single_right_single', Q<‘>,        Q<’>,       1),
;
my @identifiers = '-', Q[\'];

my $first-str = Q:to/🐧/;
  # Q_XXX
  {
    'begin': '(?x)
      (Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1':
        'name': 'string.quoted.q.operator.perl6fe'
      '2':
        'name': 'support.function.quote.adverb.perl6fe'
      '3':
        'name': 'punctuation.definition.string.perl6fe'
    'end': 'ZZZ'
    'endCaptures':
      '0':
        'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.q.XXX.quote.perl6fe'
    'patterns': [
      { 'include': '#q_XXX_string_content' }
    ]
  }
  # q_XXX
  {
    'begin': '(?x)
      (q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1':
        'name': 'string.quoted.q.operator.perl6fe'
      '2':
        'name': 'support.function.quote.adverb.perl6fe'
      '3':
        'name': 'punctuation.definition.string.perl6fe'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'endCaptures':
      '0':
        'name': 'punctuation.definition.string.perl6fe'
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
    'begin': '(?x)
      (qq(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path
        )
      )*)
      \\s*(YYY)'
    'beginCaptures':
      '1':
        'name': 'string.quoted.qq.operator.perl6fe'
      '2':
        'name': 'support.function.quote.adverb.perl6fe'
      '3':
        'name': 'punctuation.definition.string.perl6fe'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'endCaptures':
      '0':
        'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.qq.XXX.quote.perl6fe'
    'patterns': [
      {
        'match': '\\\\YYY|\\\\ZZZ'
        'name': 'constant.character.escape.perl6fe'
      }
      { 'include': '#qq_character_escape' }
      { 'include': '#interpolation' }
      { 'include': '#variables' }
      { 'include': '#q_XXX_string_content' }
    ]
  }
🐧

##sections
my $second-str = Q:to/🐧/;
  # q_XXX
  'q_XXX_string_content':
    'begin': 'YYY'
    'end': '\\\\\\\\ZZZ|(?<!\\\\)ZZZ'
    'patterns': [
      {
        'include': '#q_XXX_string_content'
      }
    ]
🐧

my $any-str = Q:to/🐧/;
    # q_any qq_any Q_any
    {
    'begin': '(?x)
      (q|qq|Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \\s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path
        )
      )*)
      \\s*([^\\w\\sZZZ])'
    'beginCaptures':
      '1':
        'name': 'string.quoted.q.operator.perl6fe'
      '2':
        'name': 'support.function.quote.adverb.perl6fe'
      '3':
        'name': 'punctuation.definition.string.perl6fe'
    'end': '\\3'
    'endCaptures':
      '0':
        'name': 'punctuation.definition.string.perl6fe'
    'contentName': 'string.quoted.q.any.quote.perl6fe'
    }
🐧

sub replace ( Str $string is copy, $name, $begin, $end ) {
  $string ~~ s:g/XXX/$name/;
  # Note: q (…) qq (…) Q (…) are only allowed with a space.
  # Note: q '…' qq '…' Q '…' are only allowed with a space.
  if ( any(@identifiers) eq $begin ) or ( $begin eq Q<\\(> and $end eq Q<\\)> ) {
    $string ~~ s:g/'\\\\s*(YYY)'/\\\\s+(YYY)/
  }
  if $begin eq $end {
    $string ~~ s:g/'\\\\\\\\YYY|\\\\\\\\ZZZ'/\\\\\\\\YYY/;
  }
  $string ~~ s:g/YYY/$begin/;
  $string ~~ s:g/ZZZ/$end/;
  $string;
}

#say @delimiters.perl;
my $first-file;
my $second-file;
#say '#1START';
for ^@delimiters -> $i {
  $first-file ~= replace($first-str, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);

}
my @not-any;
for ^@delimiters -> $i {
    if @delimiters[$i][3] eq 1 {
        push @not-any, @delimiters[$i][1] if @delimiters[$i][3] eq 1;
        push @not-any, @delimiters[$i][2] if @delimiters[$i][1] ne @delimiters[$i][2];
    }
}
my $not-any = @not-any.join('');
$any-str ~~ s/ZZZ/$not-any/;
$first-file ~= $any-str;
spurt 'FIRST.cson', $first-file;
#say '#1END';
#say '#2START';
for ^@delimiters -> $i {
  $second-file ~= replace($second-str, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);
}
spurt 'SECOND.cson', $second-file;

#say '#2END';
exit;
say replace $second-str, 'double','"', '"';
say replace $first-str, 'double', '"', '"';
say $second-str;

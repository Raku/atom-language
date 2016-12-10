#!/usr/bin/env perl6
# Generate the q[] qq[] and Q[] quoting constructs

my @open-close-delimiters =
#Left Pi right Pf. Open Ps close Pe
#name                       #open        #close      #number
('triple_paren',          Q<\\(\\(\\(>, Q<\\)\\)\\)>, 3),
('triple_bracket',        Q<\\[\\[\\[>, Q<\\]\\]\\]>, 3),
('triple_brace',          Q<\\{\\{\\{>, Q<\\}\\}\\}>, 3),
('double_angle',            '<<',        '>>',        2),
('double_paren',             Q<\\(\\(>,   Q<\\)\\)>,  2),
('double_bracket',           Q<\\[\\[>,   Q<\\]\\]>,  2),
('double_brace',            '{{',         Q<}}>,      2),
('brace',                   '{',          Q<}>,       1),
('angle',                   '<',         '>',         1),
('paren',                    Q<\\(>,      Q<\\)>,     1),
('bracket',                  Q<\\[>,      Q<\\]>,     1),
('left_double_right_double', Q<“>,        Q<”>,       1),
('left_single_right_single', Q<‘>,        Q<’>,       1),
('fw_cornerbracket',         Q<「>,       Q<」>,      1),
('hw_cornerbracket',         Q<｢>,        Q<｣>,       1),
;
my @delimiters = @open-close-delimiters;
push @delimiters, ('slash',  '/',   '/',   1);
push @delimiters, ('single', Q<\'>, Q<\'>, 1);
push @delimiters, ('double', Q<">,  Q<">,  1);
push @delimiters, ('right_double_right_double', '”', '”', 1);
# These identifiers are not allowed to be used without a space.
# Example: q '…'
my @identifiers = '-', Q[\'];

## Replace XXX with the content's name
## Replace YYY with the escaped opening delimiter
## Replace ZZZ with the escaped closing delimiter
my $q-first-str = Q:to/🐧/;
  # Q_XXX
  {
    'begin': '(?x) (?<=\\s|^|,|;)
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
    'begin': '(?x) (?<=\\s|^|,|;)
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
    'begin': '(?x) (?<=\\s|^|,|;)
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
      { 'include': 'source.perl6fe#interpolation' }
      { 'include': 'source.perl6fe#variables' }
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
    'patterns': [
      {
        'include': '#q_XXX_string_content'
      }
    ]
🐧

my $q-any-str = Q:to/🐧/;
    # q_any qq_any Q_any
    {
    'begin': '(?x) (?<=\\s|^|,|;)
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
sub replace-multiline-comment ( Str $string is copy, $name, $begin, $end ) {
    $string ~~ s:g/XXX/$name/;
    $string ~~ s:g/YYY/$begin/;
    $string ~~ s:g/ZZZ/$end/;
    $string;
}

my $zero-file;
my $first-file;
my $second-file;
# Multi line comment
for ^@open-close-delimiters -> $i {
    $zero-file ~= replace-multiline-comment $multiline-comment-str,
                          @open-close-delimiters[$i][0],
                          @open-close-delimiters[$i][1],
                          @open-close-delimiters[$i][2];
}

# q qq Q quoting constructs
for ^@delimiters -> $i {
    if use-for-q @delimiters[$i] {
        say "Skipping: {@delimiters[$i].perl}";
        next;
    }
    $first-file ~= replace($q-first-str, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);

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
my $not-any = @not-any.join('');
$q-any-str ~~ s/ZZZ/$not-any/;
$first-file ~= $q-any-str;

for ^@delimiters -> $i {
    if use-for-q @delimiters[$i] {
        say "Skipping: {@delimiters[$i].perl}";
        next;
    }
    $second-file ~= replace($q-second-str, @delimiters[$i][0], @delimiters[$i][1], @delimiters[$i][2]);
}
spurt 'ZERO.cson', $zero-file;
spurt 'FIRST.cson', $first-file;
spurt 'SECOND.cson', $second-file;
sub use-for-q ( @delimiters ) {
    # If the delimiters are equal and they are an opening, closing or begining or ending
    # unicode type symbol, then we can't use it for q/qq/Q
    @delimiters[1] eq @delimiters[2] and uniprop(@delimiters[1]) eq any('Pi', 'Pf', 'Ps', 'Pe');
}

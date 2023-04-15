#!/usr/bin/env raku
use JSON::Fast;

sub compress-wrapped($_) {
  .chomp
  .subst(/\s+/, ' ', :g)
}



# Generate the q[] qq[] and Q[] quoting constructs
my @open-close-delimiters =
#Left Pi right Pf. Open Ps close Pe
# std prop: What quoting style does it use by default?
# For example “…” quoting is like qq, while '…' is like q
#name                       #open        #close      #number #std quotes #std prop. #pod-tag?
('triple_paren',          Q<\(\(\(>, Q<\)\)\)>, 3,       False,   True),
('triple_bracket',        Q<\[\[\[>, Q<\]\]\]>, 3,       False),
('triple_brace',          Q<\{\{\{>, Q<\}\}\}>, 3,       False),
('triple_angle',             '<<<',      '>>>',       3,       False,  Nil,        True),
('double_angle',            '<<',        '>>',        2,       False,  Nil,        True),
('double_paren',             Q<\(\(>,   Q<\)\)>,  2,       False),
('double_bracket',           Q<\[\[>,   Q<\]\]>,  2,       False),
('double_brace',            '{{',         Q<}}>,      2,       False),
('brace',                   '{',          Q<}>,       1,       False),
('angle',                   '<',         '>',         1,       False,  Nil,        True),
('paren',                    Q<\(>,      Q<\)>,     1,       False),
('bracket',                  Q<\[>,      Q<\]>,     1,       False),
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
push @delimiters, ('single', Q<'>, Q<'>, 1, True, 'q');
push @delimiters, ('double', Q<">,  Q<">,  1, True, 'qq');
push @delimiters, ('right_double_right_double', '”', '”', 1, True, 'qq');
# These identifiers are not allowed to be used without a space.
# Example: q '…'
my @identifiers = '-', Q<'>;

## Replace XXX with the content's name
## Replace YYY with the escaped opening delimiter
## Replace ZZZ with the escaped closing delimiter
my $qq-quotation-marks = {
    'begin' => 'YYY',
    'beginCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.begin.raku'
      }
    },
    'end' => 'ZZZ',
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.end.raku'
      }
    },
    'name' => 'string.quoted.XXX.raku',
    'patterns' => [
      {
        'match' => Q/\\[YYYZZZabtnfre\\\{\}]/,
        'name' => 'constant.character.escape.raku'
      },
      { 'include' => '#interpolation' },
      { 'include' => 'source.quoting.raku#q_XXX_string_content' }
    ]
};
my $q-quotation-marks = {
    'begin' => Q/(?<=\W|^)YYY/,
    'beginCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.string.begin.raku'
        }
    },
    'end' => 'ZZZ',
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.end.raku'
      }
    },
    'name' => 'string.quoted.single.XXX.raku',
    'patterns' => [
      {
        'match' => Q/\\[YYYZZZ\\]/,
        'name' => 'constant.character.escape.raku'
      },
      { 'include' => 'source.quoting.raku#q_XXX_string_content' }
    ]
  }
=comment Q quoting

my $q-patterns = [
  {
    'begin' => Q:to/REGEX/.&compress-wrapped,
    (?x) (?<=^|[\[\]\s\(\){},;])
      (Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \s*(YYY)
    REGEX
    'beginCaptures' => {
      '1' => {
        'name' => 'string.quoted.q.operator.raku'
      },
      '2' => {
        'name' => 'support.function.quote.adverb.raku'
      },
      '3' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'end' => 'ZZZ',
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'contentName' => 'string.quoted.q.XXX.quote.raku',
    'patterns' => [ { 'include' => '#q_XXX_string_content' }, ]
  },
  {
    'begin' => Q:to/REGEX/.&compress-wrapped,
    (?x) (?<=^|[\[\]\s\(\){},;])
      (q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \s*(YYY)
    REGEX
    'beginCaptures' => {
      '1' => {
        'name' => 'string.quoted.q.operator.raku'
      },
      '2' => {
        'name' => 'support.function.quote.adverb.raku'
      },
      '3' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'end' => Q/\\\\ZZZ|(?<!\\)ZZZ/,
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'contentName' => 'string.quoted.q.XXX.quote.raku',
    'patterns' => [
      {
        'match' => Q/\\YYY|\\ZZZ/,
        'name' => 'constant.character.escape.raku'
      },
      { 'include' => '#q_XXX_string_content' }
    ]
  },
  {
    'begin' => Q:to/REGEX/.&compress-wrapped,
    (?x) (?<=^|[\[\]\s\(\){},;])
      (qq(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \s*(YYY)
    REGEX
    'beginCaptures' => {
      '1' => {
        'name' => 'string.quoted.qq.operator.raku'
      },
      '2' => {
        'name' => 'support.function.quote.adverb.raku'
      },
      '3' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'end' => Q/\\\\ZZZ|(?<!\\)ZZZ/,
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'contentName' => 'string.quoted.qq.XXX.quote.raku',
    'patterns' => [
      {
        'match' => Q/\\YYY|\\ZZZ/,
        'name' => 'constant.character.escape.raku'
      },
      { 'include' => '#qq_character_escape' },
      { 'include' => 'source.raku#interpolation' },
      { 'include' => '#q_XXX_string_content' }
    ]
  }
];

##sections
my &q-second = -> $XXX {
  {
    "q_$XXX<>_string_content" => {
    'begin' => 'YYY',
    'end' => Q/\\\\ZZZ|(?<!\\)ZZZ/,
    'patterns' => [ { 'include' => '#q_XXX_string_content' }, ]
  }
  }
};

my $q-any-str = {
    'begin' => Q:to/REGEX/.&compress-wrapped,
    (?x) (?<=^|[\[\]\s\(\){},;])
      (q|qq|Q(?:x|w|ww|v|s|a|h|f|c|b|p)?)
      ((?:
        \s*:(?:
          x|exec|w|words|ww|quotewords|v|val|q|single|double|
          s|scalar|a|array|h|hash|f|function|c|closure|b|blackslash|
          regexp|substr|trans|codes|p|path|nfkc|nfkd
        )
      )*)
      \s*([^\p{Ps}\p{Pe}\p{Pi}\p{Pf}\w\s])
    REGEX
    'beginCaptures' => {
      '1' => {
        'name' => 'string.quoted.q.operator.raku'
      },
      '2' => {
        'name' => 'support.function.quote.adverb.raku'
      },
      '3' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'end' => Q/\3/,
    'endCaptures' => {
      '0' => {
        'name' => 'punctuation.definition.string.raku'
      }
    },
    'contentName' => 'string.quoted.q.any.quote.raku'
};

my $multiline-comment = {
  'begin' => Q<\s*#`YYY>,
  'end' => 'ZZZ',
  'name' => 'comment.multiline.hash-tick.XXX.raku',
  'patterns' => [
    {
      'begin' => 'YYY',
      'end' => 'ZZZ',
      'name' => 'comment.internal.XXX.raku'
    },
  ]
};

my $pod-tag = [
      {
        'begin' => Q/(?x) (U) (YYY)/,
        'beginCaptures' => {
          '1' => {
            'name' => 'support.function.pod.code.raku'
          },
          '2' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'end' => Q/(?x) (ZZZ)/,
        'endCaptures' => {
          '1' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'contentName' => 'markup.underline.raku',
        'name' => 'meta.pod.c.raku',
        'patterns' => [
          { 'include' => '#comment-block-syntax' },
          { 'include' => 'source.quoting.raku#q_XXX_string_content' }
        ]
      },
      {
        'begin' => Q/(?x) (I) (YYY)/,
        'beginCaptures' => {
          '1' => {
            'name' => 'support.function.pod.code.raku'
          },
          '2' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'end' =>  Q/(?x) (ZZZ)/,
        'endCaptures' => {
          '1' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'contentName' => 'markup.italic.raku',
        'name' => 'meta.pod.c.raku',
        'patterns' => [
          { 'include' => '#comment-block-syntax' },
          { 'include' => 'source.quoting.raku#q_XXX_string_content' }
        ]
      },
      {
        'begin' => Q/(?x) (B) (YYY)/,
        'beginCaptures' => {
          '1' => {
            'name' => 'support.function.pod.code.raku'
          },
          '2' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'end' => Q/(?x) (ZZZ)/,
        'endCaptures' => {
          '1' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'contentName' => 'markup.bold.raku',
        'name' => 'meta.pod.c.raku',
        'patterns' => [
          { 'include' => '#comment-block-syntax' },
          { 'include' => 'source.quoting.raku#q_XXX_string_content' }
        ]
      },
      {
        'begin' => Q/(?x) ([A-Z]) (YYY)/,
        'beginCaptures' => {
          '1' => {
            'name' => 'support.function.pod.code.raku'
          },
          '2' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'end' =>  Q/(?x) (ZZZ)/,
        'endCaptures' => {
          '1' => {
            'name' => 'punctuation.section.embedded.pod.code.raku'
          }
        },
        'contentName' => 'markup.raw.code.raku',
        'name' => 'meta.pod.c.raku',
        'patterns' => [
          { 'include' => '#comment-block-syntax' },
          { 'include' => 'source.quoting.raku#q_XXX_string_content' }
        ]
      }
];
my $regex-tag = {
  'begin' => Q:to/REGEX/.chomp,
  (?x)
  (?<= ^|\s )
  (?:
    (m|rx|s|S)
    (
      (?:
        (?<!:P5) # < This can maybe be removed because we
        \s*:\w+
        (?!\s*:P5) # < include p5_regex above it
      )*
    )
  )
  \s*
  (YYY)
  REGEX
  'beginCaptures' => {
    '1' => {
      'name' => 'string.regexp.construct.XXX.raku'
    },
    '2' => {
      'name' => 'entity.name.section.adverb.regexp.XXX.raku'
    },
    '3' => {
      'name' => 'punctuation.definition.regexp.XXX.raku'
    }
  },
  'end' => Q/(?x) (?: (?<!\\)|(?<=\\\\) ) (ZZZ)/,
  'endCaptures' => {
    '1' => {
      'name' => 'punctuation.definition.regexp.XXX.raku'
    }
  },
  'contentName' => 'string.regexp.XXX.raku',
  'patterns' => [
    { 'include' => '#interpolation' },
    { 'include' => 'source.regexp.raku' }
  ]
};


sub use-for-q ( @delimiters ) {
    # If the delimiters are equal and they are an opening, closing or begining or ending
    # unicode type symbol, then we can't use it for q/qq/Q
    @delimiters[1] eq @delimiters[2] and uniprop(@delimiters[1]) eq any('Pi', 'Pf', 'Ps', 'Pe');
}
sub regex-highlighting {
  my @output;
  @output.append: replace($regex-tag, |@delimiters.first({.[0] eq 'slash'}).head(3));
  for @open-close-delimiters.grep(*[3] == 1) -> $delim {
    @output.append: replace($regex-tag, |$delim.head(3));
  }
  @output.append: replace($regex-tag,
    'any',
    Q‘[^#\p{Ps}\p{Pe}\p{Pi}\p{Pf}\w'\-<>\-\]\)\}\{]’,
    Q‘\3’
  );
  @output
}

sub replace ( $input, $name, $begin, $end ) {
  my $data = $input>>.clone;
  $data>>.=subst: /XXX/, $name, :g;
  # Note: q (…) qq (…) Q (…) are only allowed with a space.
  # Note: q '…' qq '…' Q '…' are only allowed with a space.
  if ( any(@identifiers) eq $begin ) or ( $begin eq Q<\(> and $end eq Q<\)> ) {
    $data>>.=subst: Q<\s*(YYY)>, Q<\s+(YYY)>, :g;
  }
  if $begin eq $end {
    $data>>.=subst: Q<\\YYY|\\ZZZ>, Q<\\YYY>, :g;
    $data>>.=subst: 'YYYZZZ', 'YYY', :g;
  }
  $data>>.=subst: 'YYY', $begin, :g;
  $data>>.=subst: 'ZZZ', $end, :g;
  $data
}
sub replace-multiline-comment ( $input, $name, $begin, $end ) {
  my $data = $input>>.clone;
  $data>>.=subst: 'XXX', $name, :g;
  $data>>.=subst: 'YYY', $begin, :g;
  $data>>.=subst: 'ZZZ', $end, :g;
  $data
}

$*PROGRAM.parent(2).&chdir;


my @*regex = regex-highlighting;

my $normal-quotes-data;
my @*zero;
my @*quoting-patterns;
my %*quoting-repo-most;
my @*comment-block-syntax-patterns-most;
for @delimiters.grep(*[6]) -> $delim {
  my ($name, $open, $close, $num, $, $, $) = $delim;
  @*comment-block-syntax-patterns-most.append: replace-multiline-comment($pod-tag, $name, $open, $close)[];
}
# Normal quotation marks
for @delimiters.grep(*[4]) -> $delim {
  my ($name, $open, $close, $num, $, $type) = $delim;
  #say $type;
  #say $bool;
  given $type {
    when 'qq' { $normal-quotes-data.append: replace($qq-quotation-marks, $name, $open, $close) }
    when 'q'  { $normal-quotes-data.append: replace($q-quotation-marks, $name, $open, $close) }
    default { say "help"; }
  }
}
#$first-data ~= $normal-quotes-data;
# Multi line comment
for @open-close-delimiters -> $delim {
    @*zero.append: replace-multiline-comment $multiline-comment,
                          $delim[0],
                          $delim[1],
                          $delim[2];
}
@*zero.append: $normal-quotes-data[];
# q qq Q quoting constructs
for @delimiters -> $delim {
    if use-for-q $delim {
        #say "Skipping: {@delimiters[$i].perl}" unless $DEBUG;
        next;
    }
    @*quoting-patterns.append: replace($q-patterns, $delim[0], $delim[1], $delim[2])[];

}
# Get list of symbols we shouldn't use for q_any (using whatever delimiter the person wants)
my @not-any;
for @delimiters.grep(*[3] == 1) -> $delim {
    push @not-any, $delim[1];
    push @not-any, $delim[2] if $delim[1] ne $delim[2];
}
#push @not-any, '@';
@not-any .= unique;
#`{{ We now use unicode properties so don't have to create a list of all the delimiters
my $not-any = @not-any.join('');
$q-any-str ~~ s/ZZZ/$not-any/;
}}
@*quoting-patterns.append: $q-any-str;

for @delimiters -> $delim {
    if use-for-q $delim {
        #say "Skipping: {@delimiters[$i].perl}" unless $DEBUG;
        next;
    }
    %*quoting-repo-most.append: replace(q-second($delim[0]), $delim[0], $delim[1], $delim[2])<>;
}
my $meta-info-tmlanguage = EVALFILE 'dev/meta-info.tmLanguage.raku';
my $raku-quoting-tmlanguage = EVALFILE 'dev/raku.quoting.tmLanguage.raku';
my $raku-regex-tmlanguage = EVALFILE 'dev/raku.regex.tmLanguage.raku';
my $raku-tmlanguage = EVALFILE 'dev/raku.tmLanguage.raku';
'grammars/meta-info.tmLanguage.json'.IO.spurt: $meta-info-tmlanguage.&to-json: :sorted-keys;
'grammars/raku.quoting.tmLanguage.json'.IO.spurt: $raku-quoting-tmlanguage.&to-json: :sorted-keys;
'grammars/raku.regex.tmLanguage.json'.IO.spurt: $raku-regex-tmlanguage.&to-json: :sorted-keys;
'grammars/raku.tmLanguage.json'.IO.spurt: $raku-tmlanguage.&to-json: :sorted-keys;
say "Done generating.";

# vim: ts=2

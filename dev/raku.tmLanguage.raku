# This file uses two external variables that it can obtain
# from the generator script:
# @*zero - the former ZERO.cson
# @*comment-block-syntax-patterns-most - the former THIRD.cson
# @*regex - the former REGEX.cson
{
  'scopeName' => 'source.raku',
  'name' => 'Raku',
  'fileTypes' => [
    'nqp',
    'raku',
    'rakumod',
    'rakudoc',
    'rakutest',
    't',
    't6',
    'p6',
    'pl6',
    'pm6',
    'pod6'
  ],
  'firstLineMatch' => '(?x) ^ \\s* (?: use \\s v6 | =begin \\s pod | =comment | \\#!(?: (?:perl6|raku)|/.*(?:perl6|raku) (?! \\S)) | my\\s*class )',
  'patterns' => [
    {
      'begin' => '^\\s*(=)(finish)',
      'beginCaptures' => {
        '1' => {
          'name' => 'storage.modifier.block.finish.raku'
        },
        '2' => {
          'name' => 'keyword.operator.block.finish.raku'
        }
      },
      'contentName' => 'comment.block.finish.raku',
      'patterns' => [
        {
          'include' => '#comment-block-syntax'
        },
      ]
    },
    {
      'include' => '#comment-block-delimited'
    },
    {
      'begin' => '^\\s*(=)(?:(para)|(for)\\s+(\\w+))',
      'beginCaptures' => {
        '1' => {
          'name' => 'storage.modifier.block.paragraph.raku'
        },
        '2' => {
          'name' => 'keyword.operator.block.paragraph.raku'
        },
        '3' => {
          'name' => 'entity.other.attribute-name.paragraph.raku'
        }
      },
      'end' => '(?=^\\s*$|^\\s*=\\w+.*$)',
      'contentName' => 'comment.block.paragraph.raku',
      'patterns' => [
        {
          'include' => '#comment-block-syntax'
        },
      ]
    },
    {
      'include' => '#comment-block-abbreviated'
    },
    {
      'match' => '^\\s*(#)([\\|\\=])(.*)\\n',
      'captures' => {
        '1' => {
          'name' => 'comment.punctuation.pound.raku'
        },
        '2' => {
          'name' => 'meta.declarator.raku'
        },
        '3' => {
          'name' => 'comment.inline.declarator.raku'
        }
      },
      'name' => 'meta.documentation.block.declarator.raku'
    },
    |@*zero,
    {
      'begin' => '(^[ \\t]+)?(?=#)',
      'beginCaptures' => {
        '1' => {
          'name' => 'punctuation.whitespace.comment.leading.raku'
        }
      },
      'end' => '(?!\\G)',
      'patterns' => [
        {
          'begin' => '#',
          'beginCaptures' => {
            '0' => {
              'name' => 'punctuation.definition.comment.raku'
            }
          },
          'end' => '\\n',
          'name' => 'comment.line.number-sign.raku'
        },
      ]
    },
    {
      'match' => '(?x) \\x{2208}|\\(elem\\)|\\x{2209}|\\!\\(elem\\)| \\x{220B}|\\(cont\\)|\\x{220C}|\\!\\(cont\\)| \\x{2286}|\\(<=\\)  |\\x{2288}|\\!\\(<=\\)  | \\x{2282}|\\(<\\)   |\\x{2284}|\\!\\(<\\)   | \\x{2287}|\\(>=\\)  |\\x{2289}|\\!\\(>=\\)  | \\x{2283}|\\(>\\)   |\\x{2285}|\\!\\(>\\)   | \\x{227C}|\\(<\\+\\)|\\x{227D}|\\(>\\+\\)   | \\x{222A}|\\(\\|\\) |\\x{2229}|\\(&\\)      | \\x{2216}|\\(\\-\\) |\\x{2296}|\\(\\^\\)    | \\x{228D}|\\(\\.\\) |\\x{228E}|\\(\\+\\)',
      'name' => 'keyword.operator.setbagmix.raku'
    },
    {
      'captures' => {
        '1' => {
          'name' => 'storage.type.class.raku'
        },
        '3' => {
          'name' => 'entity.name.type.class.raku'
        }
      },
      'match' => '(?x) ( class|enum|grammar|knowhow|module| package|role|slang|subset|monitor|actor ) (\\s+) ( ( (?:::|\')? (?: ([a-zA-Z_À-ÿ\\$]) ([a-zA-Z0-9_À-ÿ\\$]|[\\-\'][a-zA-Z0-9_À-ÿ\\$])* ) )+ )',
      'name' => 'meta.class.raku'
    },
    {
      'include' => '#p5_regex'
    },
    {
      'match' => q:to/REGEX/.chomp,
      (?x)
      (?<=
        ^
       | ^\\s
       | [\\s\\(] [^\\p{Nd}\\p{L}]
       | ~~\\s|~~\\s\\s|match\\(
       | match:\\s
      )
      ([/]) # Solidus
      (.*?) # Regex contents
      (?: (?<!\\\\)|(?<=\\\\\\\\) ) (/) # Ending
      REGEX
      'captures' => {
        '1' => {
          'name' => 'punctuation.definition.regexp.raku'
        },
        '2' => {
          'name' => 'string.regexp.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => 'source.regexp.raku'
            }
          ]
        },
        '3' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      }
    },
    {
      'begin' => q:to/REGEX/.chomp,
      (?x)
      (?<= [=,(\\[]|when|=>|~~) \\s*
      (?:
        (m|rx|s)?
        (
          (?:
            (?<!:P5) # < This can maybe be removed because we
            \\s*:\\w+
            (?!\\s*:P5) # < include p5_regex above it
          )*
        )
      ) # With the m or rx
      \\s*
      ([/]) # Solidus
      REGEX
      'end' => '(?x) (?: (?<!\\\\)|(?<=\\\\\\\\)|(?<!\')|(?<=\\\\ \') ) (/)',
      'beginCaptures' => {
        '1' => {
          'name' => 'string.regexp.construct.raku'
        },
        '2' => {
          'name' => 'entity.name.section.adverb.regexp.raku'
        },
        '3' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'endCaptures' => {
        '1' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'contentName' => 'string.regexp.raku',
      'patterns' => [
        {
          'include' => '#interpolation'
        },
        {
          'include' => 'source.regexp.raku'
        }
      ]
    },
    {
      'begin' => q:to/REGEX/.chomp,
      (?x)
      (?<= ^|[=,(\\[~]|when|=> ) \\s*
      (?:
        (m|rx|s)
        (
          (?:
            (?<!:P5) # < This can maybe be removed because we
            \\s*:\\w+
            (?!\\s*:P5) # < include p5_regex above it
          )*
        )
      ) # With the m or rx
      \\s*
      ([{]) # Left curly brace
      REGEX
      'beginCaptures' => {
        '1' => {
          'name' => 'string.regexp.construct.raku'
        },
        '2' => {
          'name' => 'entity.name.section.adverb.regexp.raku'
        },
        '3' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'end' => '(?x) (?: (?<!\\\\)|(?<=\\\\\\\\) ) (\\})',
      'endCaptures' => {
        '1' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'contentName' => 'fstring.regexp.raku',
      'patterns' => [
        {
          'include' => '#interpolation'
        },
        {
          'include' => 'source.regexp.raku'
        }
      ]
    },
    {
      'begin' => '(?<![\\w\\/])(m|rx)((?:\\s*:\\w+)*)\\s*(\\{)',
      'beginCaptures' => {
        '1' => {
          'name' => 'string.regexp.construct.raku'
        },
        '2' => {
          'name' => 'entity.name.section.adverb.regexp.raku'
        },
        '3' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'end' => '(?<!\\\\)(\\})',
      'endCaptures' => {
        '1' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'contentName' => 'string.regexp.raku',
      'patterns' => [
        {
          'include' => '#interpolation'
        },
        {
          'include' => 'source.regexp.raku'
        }
      ]
    },
    {
      'begin' => '(?<![\\w\\/])(m|rx)((?:\\s*:\\w+)*)\\s*(\\[)',
      'beginCaptures' => {
        '1' => {
          'name' => 'string.regexp.construct.raku'
        },
        '2' => {
          'name' => 'entity.name.section.adverb.regexp.raku'
        },
        '3' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'end' => '(?<!\\\\)(\\])',
      'endCaptures' => {
        '1' => {
          'name' => 'punctuation.definition.regexp.raku'
        }
      },
      'contentName' => 'string.regexp.raku',
      'patterns' => [
        {
          'include' => '#interpolation'
        },
        {
          'include' => 'source.regexp.raku'
        }
      ]
    },
    {
      'begin' => '(?<=\\W|^)｢',
      'beginCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.string.begin.raku'
        }
      },
      'end' => '｣',
      'endCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.string.end.raku'
        }
      },
      'name' => 'string.quoted.single.raku',
      'patterns' => [
        {
          'include' => 'source.quoting.raku#q_hw_cornerbracket_string_content'
        },
      ]
    },
    |@*regex,
    {
      'include' => '#shellquotes'
    },
    {
      'begin' => '(?x) (?: ( qq|qqx|qqw ) \\s* ( (?:\\s*:\\w+)*\\s*: (?: to|heredoc ) )\\s* | (qqto) \\s* ( (?:\\s*:\\w+)* )\\s* ) / (\\S+) /',
      'beginCaptures' => {
        '1' => {
          'name' => 'string.quoted.construct.raku'
        },
        '2' => {
          'name' => 'support.function.adverb.raku'
        },
        '3' => {
          'name' => 'string.quoted.construct.raku'
        },
        '4' => {
          'name' => 'support.function.adverb.raku'
        },
        '5' => {
          'name' => 'entity.other.attribute-name.heredoc.delimiter.raku'
        }
      },
      'end' => '\\s*\\5',
      'endCaptures' => {
        '0' => {
          'name' => 'entity.other.attribute-name.heredoc.delimiter.raku'
        }
      },
      'patterns' => [
        {
          'begin' => '(?<=/)',
          'end' => '\\n',
          'patterns' => [
            {
              'include' => '$self'
            },
          ],
          'name' => 'meta.heredoc.continuation.raku'
        },
        {
          'begin' => '^',
          'end' => '$',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
          ]
        },
        {
          'match' => '(?x) ^ (?: . | \\n )* $',
          'name' => 'string.quoted.qq.heredoc.raku'
        }
      ],
      'name' => 'string.quoted.heredoc.raku'
    },
    {
      'begin' => '(?x) (?: ( [qQ](?!/)|qw|qww|qx|qqx ) \\s* ( (?:\\s*:\\w+)*\\s*: (?: to|heredoc ) )\\s* | (qto|Qto) \\s* ( (?:\\s*:\\w+)* )\\s* ) / (\\S+) /',
      'beginCaptures' => {
        '1' => {
          'name' => 'string.quoted.construct.raku'
        },
        '2' => {
          'name' => 'support.function.adverb.raku'
        },
        '3' => {
          'name' => 'string.quoted.construct.raku'
        },
        '4' => {
          'name' => 'support.function.adverb.raku'
        },
        '5' => {
          'name' => 'entity.other.attribute-name.heredoc.delimiter.raku'
        }
      },
      'end' => '\\s*\\5',
      'endCaptures' => {
        '0' => {
          'name' => 'entity.other.attribute-name.heredoc.delimiter.raku'
        }
      },
      'patterns' => [
        {
          'begin' => '(?<=/)',
          'end' => '\\n',
          'patterns' => [
            {
              'include' => '$self'
            },
          ],
          'name' => 'meta.heredoc.continuation.raku'
        },
        {
          'match' => '(?x) ^ (?: . | \\n )* $',
          'name' => 'string.quoted.q.heredoc.raku'
        }
      ],
      'name' => 'meta.heredoc.raku'
    },
    {
      'include' => 'source.quoting.raku'
    },
    {
      'include' => '#variables'
    },
    {
      'begin' => '(?x) (?<![%$&@]|\\w) (?:  (multi|proto) \\s+ )? (macro|sub|submethod|method|multi|only|category) \\s+ (!)? (  [^\\s(){}]+ )',
      'beginCaptures' => {
        '1' => {
          'name' => 'storage.type.declarator.multi.raku'
        },
        '2' => {
          'name' => 'storage.type.declarator.type.raku'
        },
        '3' => {
          'name' => 'support.class.method.private.raku'
        },
        '4' => {
          'patterns' => [
            {
              'match' => Q/(?x) ( [\p{Digit}\pL\pM'\-_]+ ) \b (:)? (\w+ \b )? (\S+  )?/,
              'captures' => {
                '1' => {
                  'name' => 'entity.name.function.raku'
                },
                '2' => {
                  'name' => 'punctuation.definition.function.adverb.raku'
                },
                '3' => {
                  'name' => 'support.type.class.adverb.raku'
                },
                '4' => {
                  'patterns' => [
                    {
                      'include' => '$self'
                    }
                  ]
                }
              }
            },
          ]
        }
      },
      'end' => '(?=[\\(\\{\\s])'
    },
    {
      'begin' => '(?<![\\.:])(regex|rule|token)(?!\\s*=>|\\S)',
      'beginCaptures' => {
        '1' => {
          'name' => 'storage.type.declare.regexp.named.raku'
        }
      },
      'end' => '(?<!\\\\)\\}',
      'endCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.regexp.named.raku'
        }
      },
      'name' => 'meta.regexp.named.raku',
      'patterns' => [
        {
          'match' => 'TOP',
          'name' => 'entity.name.function.regexp.named.TOP.raku'
        },
        {
          'match' => Q/[\p{Digit}\pL\pM'\-_]+/,
          'name' => 'entity.name.function.regexp.named.raku'
        },
        {
          'match' => '(:)(\\w+)',
          'captures' => {
            '1' => {
              'name' => 'punctuation.definition.regexp.adverb.raku'
            },
            '2' => {
              'name' => 'support.type.class.adverb.raku'
            }
          },
          'name' => 'meta.regexp.named.adverb.raku'
        },
        {
          'begin' => '<',
          'end' => '(?x) \\\\\\\\|(?<!\\\\) ( > ) (?=[\\s\\{])',
          'contentName' => 'string.array.words.raku'
        },
        {
          'begin' => '«',
          'end' => '(?x)  \\\\\\\\|(?<!\\\\) ( » ) (?=[\\s\\{])',
          'contentName' => 'string.array.words.chevron.raku'
        },
        {
          'begin' => '\\(',
          'end' => '(?<!\\\\)\\)',
          'captures' => {
            '0' => {
              'name' => 'punctuation.definition.regexp.named.signature.perlfe'
            }
          },
          'name' => 'meta.regexp.named.signature.raku',
          'patterns' => [
            {
              'include' => '$self'
            },
          ]
        },
        {
          'begin' => '\\{',
          'end' => '(?=\\})',
          'captures' => {
            '0' => {
              'name' => 'punctuation.definition.regex.named.raku'
            }
          },
          'name' => 'meta.regexp.named.block.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => 'source.regexp.raku'
            }
          ]
        }
      ]
    },
    {
      'match' => '\\b(?<![\\-:])(self)(?!\\-)\\b',
      'name' => 'variable.language.raku'
    },
    {
      'match' => '\\b(?<![\\-:])(use|require|no|need)(?!\\-)\\b',
      'name' => 'keyword.other.include.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:])( if|else|elsif|unless|with|orwith|without )(?!\\-)\\b',
      'name' => 'keyword.control.conditional.raku'
    },
    {
      'match' => '\\b(?<![\\-:])(let|my|our|state|temp|has|constant)(?!\\-)\\b',
      'name' => 'storage.modifier.declarator.raku'
    },
    {
      'begin' => '(?x) (?<= = | for ) \\s* ( < )',
      'beginCaptures' => {
        '1' => {
          'name' => 'span.keyword.operator.array.words.raku'
        }
      },
      'end' => '(?x)  \\\\\\\\|(?<!\\\\) ( > )',
      'endCaptures' => {
        '1' => {
          'name' => 'span.keyword.operator.array.words.raku'
        }
      },
      'contentName' => 'string.array.words.raku',
      'patterns' => [
        {
          'include' => 'source.quoting.raku#q_bracket_string_content'
        },
      ]
    },
    {
      'match' => '(?x) (?: [+:\\-.*/] | \\|\\| )? (?<! = ) = (?! [>=~] )',
      'name' => 'storage.modifier.assignment.raku'
    },
    {
      'begin' => '(?x) (?<! \\+< | \\+\\s|\\+ ) \\s* (<) (?<! > ) (?= [^<]* (?: [^<] ) > )',
      'beginCaptures' => {
        '1' => {
          'name' => 'span.keyword.operator.array.words.raku'
        }
      },
      'end' => '(?x) \\\\\\\\|(?<!\\\\) ( > )',
      'endCaptures' => {
        '1' => {
          'name' => 'span.keyword.operator.array.words.raku'
        }
      },
      'contentName' => 'string.array.words.raku'
    },
    {
      'match' => '\\b(for|loop|repeat|while|until|gather|given)(?!\\-)\\b',
      'name' => 'keyword.control.repeat.raku'
    },
    {
      'match' => q:to/REGEX/.chomp,
      (?x)
      \\b (?<! [\\-:.] )
      (
         take|do|when|next|last|redo|return|return-rw
        |contend|maybe|defer|default|exit|quietly
        |continue|break|goto|leave|supply
        |async|lift|await|start|react|whenever|parse
      )
      (?! - ) \\b
      REGEX
      'name' => 'keyword.control.flowcontrol.raku'
    },
    {
      'match' => q:to/REGEX/.chomp,
      (?x)
      \\b (?<! [\\-:] )
      (
        make|made
      )
      (?! - ) \\b
      REGEX
      'name' => 'keyword.control.flowcontrol.regex.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:]) (is|does|as|but|trusts|of|returns|handles|where|augment|supersede) (?!\\-)\\b (?!\\s*=>)',
      'name' => 'storage.modifier.type.constraints.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:])( BEGIN|CHECK|INIT |START|FIRST|ENTER |LEAVE|KEEP|UNDO |NEXT|LAST|PRE |POST|END|CATCH |CONTROL|TEMP|QUIT )(?!\\-)\\b',
      'name' => 'keyword.control.closure.trait.raku'
    },
    {
      'match' => '\\b(?<![\\-:])(die|fail|try|warn)(?!\\-)\\b(?!\\s*=>)',
      'name' => 'keyword.control.control-handlers.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:])( prec|irs|ofs|ors|export|raw|deep |binary|unary|reparsed|rw|parsed |cached|readonly|defequiv|will |ref|copy|inline|tighter|looser |equiv|assoc|required|pure )(?!\\-)\\b  (?!\\s*=>)',
      'name' => 'entity.name.type.trait.raku'
    },
    {
      'match' => '\\b(NaN|Inf)(?!\\-)\\b',
      'name' => 'constant.numeric.raku'
    },
    {
      'match' => '\\b(True|False)\\b',
      'name' => 'constant.language.boolean.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:])( fatal|internals| MONKEY\\-(?:TYPING|SEE\\-NO\\-EVAL|BRAINS|GUTS|BUSINESS|TRAP|SHINE|WRENCH|BARS)| nqp|QAST|strict|trace|worries|invocant|parameters|experimental| cur|soft|variables|attributes|v6(?:\\.\\w)*|lib|Test|NativeCall )(?!\\-) \\b (?!\\s*=>)',
      'name' => 'constant.language.pragma.raku'
    },
    {
      'match' => '(?x)(?<![:\\-\\w]) (Backtrace|Exception|Failure|X) (?: \\:\\:[a-zA-Z]+ )* \\b',
      'captures' => {
        '0' => {
          'name' => 'support.type.exception.raku'
        }
      }
    },
    {
      'match' => q:to/REGEX/.chomp,
      (?x)\\b(?<!:)(
        AST|Any|Array|Associative|Attribute|Bag|BagHash|Baggy|
        Blob|Block|Bool|Callable|Capture|Channel|Code|Complex|Cool|
        CurrentThreadScheduler|Cursor|Date|DateTime|Dateish|Duration|
        Enum|FatRat|Grammar|Hash|IO|Instant|Iterable|
        Iterator|Junction|Label|List|Lock|Macro|Map|Match|Metamodel|
        Method|Mix|MixHash|Mixy|Mu|Nil|Numeric|ObjAt|Pair|
        Parameter|Pod|Positional|PositionalBindFailover|Proc|Promise|
        Proxy|QuantHash|Range|Rat|Rational|Real|Regex|Routine|Scheduler|
        Seq|Set|SetHash|Setty|Signature|Slip|Stash|Str|str|Stringy|Sub|
        Submethod|Supply|Tap|Temporal|Thread|ThreadPoolScheduler|
        Variable|Version|Whatever|WhateverCode|bool|size_t|
        Int|int|int1|int2|int4|int8|int16|int32|int64|
        Rat|rat|rat1|rat2|rat4|rat8|rat16|rat32|rat64|
        Buf|buf|buf1|buf2|buf4|buf8|buf16|buf32|buf64|
        UInt|uint|uint1|uint2|uint4|uint8|uint16|uint32|uint64|
        utf8|utf16|utf32|Num|num|num32|num64|IntStr|NumStr|
        RatStr|ComplexStr|CArray|Pointer|long|longlong|
        # These are for types which have sub types
        Order|More|Less|Same
      )\\b (?!\\s*=>)
      REGEX
      'captures' => {
        '1' => {
          'name' => 'support.type.raku'
        },
        '2' => {
          'name' => 'support.class.type.adverb.raku'
        }
      }
    },
    {
      'match' => '(?x) ( \\[ / \\] )',
      'name' => 'keyword.operator.reduction.raku'
    },
    {
      'match' => '(?<=\\w)(\\:)([DU_])\\b',
      'name' => 'meta.adverb.definedness.raku',
      'captures' => {
        '1' => {
          'name' => 'keyword.operator.adverb.raku'
        },
        '2' => {
          'name' => 'keyword.other.special-method.definedness.raku'
        }
      }
    },
    {
      'match' => '(?x)\\b( div|mod|gcd|lcm|x|xx|temp|let|but|cmp|leg| eq|ne|gt|ge|lt|le|before|after|eqv|min|max|ff|fff|not|so|Z| and|andthen|or|orelse )\\b(?!\\-)| \\b(X)(?!:)\\b',
      'name' => 'keyword.operator.word.raku'
    },
    {
      'match' => '(=~=|≅)',
      'captures' => {
        '1' => {
          'name' => 'keyword.operator.approx-equal.raku'
        }
      },
      'name' => 'meta.operator.non.ligature.raku'
    },
    {
      'match' => '(?x) <== | ==> | <=> | => | --> | -> | \\+\\| | \\+\\+ | -- | \\*\\* | \\?\\?\\? | \\?\\? | \\!\\!\\! | \\!\\! | && | \\+\\^ | \\?\\^ | %% | \\+& | \\+< | \\+> | \\+\\^ | \\.\\.(?!\\.) | \\.\\.\\^ | \\^\\.\\. | \\^\\.\\.\\^ | \\?\\| | !=(?!\\=) | !==(?!\\=) | <=(?!>) | >= | === | == | =:= | ~~ | \\x{2245} | \\|\\| | \\^\\^ | \\/\\/ | := | ::= | \\.\\.\\.',
      'name' => 'keyword.operator.multi-symbol.raku'
    },
    {
      'include' => '#special_variables'
    },
    {
      'match' => '(?x)(?<=\\[) \\s* (\\*) \\s* ([\\-\\*%\\^\\+\\/]|div|mod|gcd|lcm) \\s* (\\d+) \\s* (?=\\])',
      'name' => 'meta.subscript.whatever.raku',
      'captures' => {
        '1' => {
          'name' => 'constant.language.whatever.raku'
        },
        '2' => {
          'name' => 'keyword.operator.minus.back-from.raku'
        },
        '3' => {
          'name' => 'constant.numeric.back-from.raku'
        }
      }
    },
    {
      'match' => '\\*\\s*(?=\\])',
      'name' => 'constant.language.whatever.hack.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-\\\\])( :: )?(exists)(?!\\-)\\b(?!\\s*=>)',
      'captures' => {
        '1' => {
          'name' => 'keyword.operator.colon.raku'
        }
      },
      'name' => 'support.function.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:\\\\])( :: )?( eager|hyper|substr|index|rindex|grep|map|sort|join|lines|hints |chmod|split|reduce|min|max|reverse|truncate|zip|cat|roundrobin |classify|first|sum|keys|values|pairs|defined|delete|exists |elems|end|kv|any|all|one|wrap|shape|key|value|name|pop|push |shift|splice|unshift|floor|ceiling|abs|exp|log|log10|rand|sign |sqrt|sin|cos|tan|round|strand|roots|cis|unpolar|polar|atan2 |pick|chop|chomp|lc|lcfirst|uc|ucfirst|capitalize|mkdir |normalize|pack|unpack|quotemeta|comb|samecase|sameaccent|chars |nfd|nfc|nfkd|nfkc|printf|sprintf|caller|evalfile|run|runinstead |nothing|want|bless|chr|ord|ords|gmtime|time|eof|localtime|gethost |getpw|chroot|getlogin|getpeername|kill|fork|wait|perl|graphs |codes|bytes|clone|print|open|read|write|readline|say|seek|close |opendir|readdir|slurp|spurt|shell|run|pos|fmt|vec|link|unlink |symlink|unique|pair|asin|atan|sec|cosec|cotan|asec|acosec|acotan |sinh|cosh|tanh|asinh|done|acos|acosh|atanh|sech|cosech|cotanh |sech|acosech|acotanh|asech|ok|nok|plan-ok|dies-ok|lives-ok|skip |todo|pass|flunk|force-todo|use-ok|isa-ok|diag|is-deeply|isnt |like|skip-rest|unlike|cmp-ok|eval-dies-ok|nok-error|cmp-ok |eval-lives-ok|approx|is-approx|throws-ok|version-lt|plan|EVAL |succ|pred|times|nonce|once|signature|new|connect|operator|undef |undefine|sleep|from|to|infix|postfix|prefix|circumfix|can-ok |postcircumfix|minmax|lazy|count|unwrap|getc|pi|tau|context|void |quasi|body|each|contains|rewinddir|subst|can|isa|flush|arity |assuming|rewind|callwith|callsame|nextwith|nextsame|attr|does-ok |eval-elsewhere|none|not|srand|so|trim|trim-start|trim-end|lastcall |WHAT|WHY|WHERE|HOW|WHICH|VAR|WHO|WHENCE|ACCEPTS|REJECTS|not |iterator|by|re|im|invert|flip|gist|flat|tree|is-prime |throws-like|trans|race|hyper|tap|emit|done-testing|quit|dd|note |prepend|categorize|antipairs|categorize-list|parse-base|base |starts-with|ends-with|put|append|tail|\\x{03C0}|\\x{03C4}|\\x{212F} |get|words|new-from-pairs|uniname|uninames|uniprop|uniprops |slurp-rest|throw|break|keep|match|trim-leading|trim-trailing |is-lazy|pull-one|push-exactly|push-at-least|push-all|push-until-lazy |sink-all|skip-at-least|skip-at-least-pull-one )(?!\\-)\\b(?!\\s*=>)',
      'captures' => {
        '1' => {
          'name' => 'keyword.operator.colon.raku'
        }
      },
      'name' => 'support.function.raku'
    },
    {
      'match' => '(?x)\\b(?<![\\-:]|\\\\)(?<=\\.) (e|d|f|s|l|r|w|rw|x|rwx|z|abspath|basename|extension|dirname |watch|is-absolute|parts|volume|path|is-relative|parent|child |resolve|dir) (?!\\-)\\b(?!\\s*=>)',
      'name' => 'support.function.raku'
    },
    {
      'include' => '#numbers'
    },
    {
      'match' => '(?x) (?<!\\(|\\*)\\%| [\\^\\+><\\*\\!\\?~\\/\\|]| (?<!\\$)\\.| (?<!:):(?!:)| (?<=\\s)\\-(?=[\\s\\(\\{\\[])| (?<!\\w)[o\\x{2218}](?!\\w)',
      'name' => 'keyword.operator.generic.raku'
    },
    {
      'match' => '(?x) (?<=^|\\W|\\s) ([\\w\'\\-]+) \\s* (?= =>)',
      'name' => 'string.pair.key.raku'
    },
    {
      'match' => '(?x) \\b (?<!\\d) ([a-zA-Z_\\x{c0}-\\x{ff}\\$]) ( [a-zA-Z0-9_\\x{c0}-\\x{ff}\\$]| [\\-\'][a-zA-Z_\\x{c0}-\\x{ff}\\$][a-zA-Z0-9_\\x{c0}-\\x{ff}\\$] )*',
      'name' => 'routine.name.raku'
    },
    {
      'begin' => '(?<=\\:)(\\d+)(<)',
      'beginCaptures' => {
        '1' => {
          'name' => 'support.type.radix.raku'
        },
        '2' => {
          'name' => 'punctuation.definition.radix.raku'
        }
      },
      'end' => '>',
      'endCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.radix.raku'
        }
      },
      'contentName' => 'constant.numeric.raku'
    },
    {
      'begin' => '\\{',
      'beginCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.block.raku'
        }
      },
      'end' => '\\}',
      'endCaptures' => {
        '0' => {
          'name' => 'punctuation.definition.block.raku'
        }
      },
      'name' => 'meta.block.raku',
      'patterns' => [
        {
          'include' => '$self'
        },
      ]
    }
  ],
  'repository' => {
    'numbers' => {
      'patterns' => [
        {
          'match' => q:to/REGEX/.chomp,
          (?x)
          (?<= ^ | [=,;^\\s{\\[(/] | \\.\\. )
          [-−+]?
          0[bodx]\\w+
          REGEX
          'name' => 'constant.numeric.radix.raku'
        },
        {
          'match' => q:to/REGEX/.chomp,
          (?x)
                    (?<= ^ | [×÷*=,:;^\\s{\\[(/] | \\.\\. | … )
                    (?: \\^? [+\\-−] )?
          (?:
              (?: \\d+ (?: [\\_\\d]+ \\d )? )
              (?: \\.  \\d+ (?: [\\_\\d]+ \\d )? )?
          )
          (?:  e  (?:-|−)? \\d+ (?: [\\_\\d]+ \\d )? )?
          REGEX
          'name' => 'constant.numeric.raku'
        },
        {
          'match' => q:to/REGEX/.chomp,
          (?x)
                    (?<= ^ | [×÷*=,:;^\\s{\\[(/] | \\.\\. )
                    (?: [+-−] )?
          (?:
              (?: \\.  \\d+ (?: [\\_\\d]+ \\d )? )
          )
          (?:  e  (?:-|−)? \\d+ (?: [\\_\\d]+ \\d )? )?
          REGEX
          'name' => 'constant.numeric.raku'
        }
      ]
    },
    'comment-block-delimited' => {
      'patterns' => [
        {
          'begin' => '^\\s*(=)(begin)\\s+(\\w+)',
          'end' => '^\\s*(=)(end)\\s+(\\w+)',
          'captures' => {
            '1' => {
              'name' => 'storage.modifier.block.delimited.raku'
            },
            '2' => {
              'name' => 'keyword.operator.block.delimited.raku'
            },
            '3' => {
              'name' => 'entity.other.attribute-name.block.delimited.raku'
            }
          },
          'contentName' => 'comment.block.delimited.raku',
          'patterns' => [
            {
              'include' => '#comment-block-syntax'
            }
          ]
        },
      ]
    },
    'comment-block-abbreviated' => {
      'patterns' => [
        {
          'begin' => '^\\s*(=)(head\\w*)\\s+(.+?)\\s*$',
          'end' => '(?=^\\s*$|^\\s*=\\w+.*$)',
          'captures' => {
            '1' => {
              'name' => 'storage.modifier.block.abbreviated.raku'
            },
            '2' => {
              'name' => 'entity.other.attribute-name.block.abbreviated.raku'
            },
            '3' => {
              'name' => 'entity.name.section.abbreviated.raku',
              'patterns' => [
                {
                  'include' => '#comment-block-syntax'
                },
              ]
            }
          },
          'contentName' => 'entity.name.section.head.abbreviated.raku',
          'patterns' => [
            {
              'include' => '#comment-block-syntax'
            },
          ]
        },
        {
          'begin' => '^\\s*(=)(\\w+)\\s+(.+?)\\s*$',
          'end' => '(?=^\\s*$|^\\s*=\\w+.*$)',
          'captures' => {
            '1' => {
              'name' => 'storage.modifier.block.abbreviated.raku'
            },
            '2' => {
              'name' => 'entity.other.attribute-name.block.abbreviated.raku'
            },
            '3' => {
              'name' => 'entity.name.section.abbreviated.raku',
              'patterns' => [
                {
                  'include' => '#comment-block-syntax'
                },
              ]
            }
          },
          'contentName' => 'comment.block.abbreviated.raku',
          'patterns' => [
            {
              'include' => '#comment-block-syntax'
            },
          ]
        }
      ]
    },
    'shellquotes' => {
      'patterns' => [
        {
          'begin' => '([qQ]x)\\s*({{)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '}}',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            },
          ]
        },
        {
          'begin' => '([qQ]x)\\s*({)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '}',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            },
          ]
        },
        {
          'begin' => '([qQ]x)\\s*(\\[\\[)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\]\\]',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            },
          ]
        },
        {
          'begin' => '([Qq]x)\\s*(\\[)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\]',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            },
          ]
        },
        {
          'begin' => '([Qq]x)\\s*(\\|)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\|',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            },
          ]
        },
        {
          'begin' => '([Qq]x)\\s*(\\/)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '(?<!\\\\)\\/',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.single.raku',
          'patterns' => [
            {
              'match' => '\\\\\\/',
              'name' => 'constant.character.escape.raku'
            },
            {
              'include' => 'source.quoting.raku#q_single_string_content'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*({{)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '}}',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*({)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '}',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*(\\[\\[)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\]\\]',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*(\\[)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\]',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*(\\|)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '\\|',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        },
        {
          'begin' => '(qqx)\\s*(\\/)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.quoted.q.shell.operator.raku'
            },
            '2' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'end' => '(?<!\\\\)\\/',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.section.embedded.shell.begin.raku'
            }
          },
          'name' => 'meta.shell.quote.double.raku',
          'patterns' => [
            {
              'match' => '\\\\\\/',
              'name' => 'constant.character.escape.raku'
            },
            {
              'include' => '#interpolation'
            },
            {
              'include' => '#variables'
            },
            {
              'include' => 'source.shell'
            }
          ]
        }
      ]
    },
    'comment-block-syntax' => {
      'patterns' => [
        {
          'include' => '#comment-block-delimited'
        },
        {
          'include' => '#comment-block-abbreviated'
        },
        |@*comment-block-syntax-patterns-most
      ]
    },
    'p5_regex' => {
      'patterns' => [
        {
          'begin' => '(?x)(?<![\\w\\/])(m|rx) \\s*((?:\\s*:\\w+)*)?(:P5)((?:\\s*:\\w+)*)?\\s* (\\{)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.regexp.construct.raku'
            },
            '2' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '3' => {
              'name' => 'entity.name.section.p5.adverb.regexp.raku'
            },
            '4' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '5' => {
              'name' => 'punctuation.definition.regexp.raku'
            }
          },
          'end' => '(?<!\\\\)(\\})([gmixXsuUAJ]+)?',
          'endCaptures' => {
            '1' => {
              'name' => 'punctuation.definition.regexp.raku'
            },
            '2' => {
              'name' => 'invalid.illegal.p5.regexp.modifier.raku'
            }
          },
          'contentName' => 'string.regexp.p5.raku',
          'patterns' => [
            {
              'include' => '#p5_escaped_char'
            },
            {
              'include' => 'source.quoting.raku#q_brace_string_content'
            }
          ]
        },
        {
          'begin' => '(?x)(?<![\\w\\/])(m|rx) \\s*((?:\\s*:\\w+)*)?(:P5)((?:\\s*:\\w+)*)?\\s* (\\[)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.regexp.construct.raku'
            },
            '2' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '3' => {
              'name' => 'entity.name.section.p5.adverb.regexp.raku'
            },
            '4' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '5' => {
              'name' => 'punctuation.definition.regexp.raku'
            }
          },
          'end' => '(?<!\\\\)(\\])([gmixXsuUAJ]+)?',
          'endCaptures' => {
            '1' => {
              'name' => 'punctuation.definition.regexp.raku'
            },
            '2' => {
              'name' => 'invalid.illegal.p5.regexp.modifier.raku'
            }
          },
          'contentName' => 'string.regexp.p5.raku',
          'patterns' => [
            {
              'include' => '#p5_escaped_char'
            },
            {
              'include' => 'source.quoting.raku#q_bracket_string_content'
            }
          ]
        },
        {
          'begin' => '(?x)(?<![\\w\\/])(m|rx) \\s*((?:\\s*:\\w+)*)?(:P5)((?:\\s*:\\w+)*)?\\s* (\\/)',
          'beginCaptures' => {
            '1' => {
              'name' => 'string.regexp.construct.raku'
            },
            '2' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '3' => {
              'name' => 'entity.name.section.p5.adverb.regexp.raku'
            },
            '4' => {
              'name' => 'entity.name.section.adverb.regexp.raku'
            },
            '5' => {
              'name' => 'punctuation.definition.regexp.raku'
            }
          },
          'end' => '(?<!\\\\)(\\/)([gmixXsuUAJ]+)?',
          'endCaptures' => {
            '1' => {
              'name' => 'punctuation.definition.regexp.raku'
            },
            '2' => {
              'name' => 'invalid.illegal.p5.regexp.modifier.raku'
            }
          },
          'contentName' => 'string.regexp.p5.raku',
          'patterns' => [
            {
              'include' => '#p5_escaped_char'
            },
            {
              'include' => 'source.quoting.raku#q_slash_string_content'
            }
          ]
        }
      ]
    },
    'p5_escaped_char' => {
      'patterns' => [
        {
          'match' => '\\\\\\d+',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\c[^\\s\\\\]',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\g(?:\\{(?:\\w*|-\\d+)\\}|\\d+)',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\k(?:\\{\\w*\\}|<\\w*>|\'\\w*\')',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\N\\{[^\\}]*\\}',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\o\\{\\d*\\}',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\(?:p|P)(?:\\{\\w*\\}|P)',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\x(?:[0-9a-zA-Z]{2}|\\{\\w*\\})?',
          'name' => 'constant.character.escape.perl'
        },
        {
          'match' => '\\\\.',
          'name' => 'constant.character.escape.perl'
        }
      ]
    },
    'special_variables' => {
      'patterns' => [
        {
          'match' => '(?x) [\\$\\@](?=[\\s,;\\{\\[\\(])| (?<=[\\(\\,])\\s*%(?![\\w\\*\\!\\?\\.\\^:=~])| \\$_| \\$\\/| \\$\\!(?!\\w)| \\$\\d(?!\\w)',
          'name' => 'keyword.other.special-method.raku'
        },
      ]
    },
    'regexp-variables' => {
      'patterns' => [
        {
          'begin' => '\\$(?=\\<)',
          'beginCaptures' => {
            '0' => {
              'name' => 'variable.other.identifier.sigil.regexp.perl6'
            }
          },
          'end' => '(?![\\w\\<\\>])',
          'name' => 'meta.match.variable.raku',
          'patterns' => [
            {
              'match' => '(\\<)([\\w\\-]+)(\\>)',
              'captures' => {
                '1' => {
                  'name' => 'support.class.match.name.delimiter.regexp.raku'
                },
                '2' => {
                  'name' => 'variable.other.identifier.regexp.perl6'
                },
                '3' => {
                  'name' => 'support.class.match.name.delimiter.regexp.raku'
                }
              }
            },
          ]
        },
      ]
    },
    'variables' => {
      'patterns' => [
        {
          'include' => '#regexp-variables'
        },
        {
          'match' => Q:to/REGEX/.chomp,
          (?x)
          (\$|@|%|&)
          (\.|\*|:|!|\^|~|=|\?)?
          (
              (?:[\pL\pM_])           # Must start with Alpha or underscore
              (?:
                 [\\p{Digit}\pL\pM_]  # have alphanum/underscore, or a ' or -
              |                           # followed by an Alpha or underscore
                 [\-'] [\pL\pM_]
              )*
          )
          REGEX
          'captures' => {
            '1' => {
              'name' => 'variable.other.identifier.sigil.raku'
            },
            '2' => {
              'name' => 'support.class.twigil.raku'
            },
            '3' => {
              'name' => 'variable.other.identifier.raku'
            }
          },
          'name' => 'meta.variable.container.raku'
        }
      ]
    },
    'hex_escapes' => {
      'patterns' => [
        {
          'match' => '(?x) (\\\\x) ( \\[ ) ( [\\dA-Fa-f]+ ) ( \\] )',
          'captures' => {
            '1' => {
              'name' => 'keyword.punctuation.hex.raku'
            },
            '2' => {
              'name' => 'keyword.operator.bracket.open.raku'
            },
            '3' => {
              'name' => 'routine.name.hex.raku'
            },
            '4' => {
              'name' => 'keyword.operator.bracket.close.raku'
            }
          },
          'name' => 'punctuation.hex.raku'
        },
      ]
    },
    'interpolation' => {
      'patterns' => [
        {
          'match' => Q:to/REGEX/.chomp,
          (?x)
          (?<!\\)
          (\$|@|%|&)
          (?!\$)
          (\.|\*|:|!|\^|~|=|\?)?  # Twigils
          ([\pL\pM_])             # Must start with Alpha or underscore
          (
             [\p{Digit}\pL\pM_]  # have alphanum/underscore, or a ' or -
          |                           # followed by an Alpha or underscore
             [\-'] [\pL\pM_]
          )*
          ( \[ .* \] )?             # postcircumfix [ ]
          ## methods
          (?:
            (?:
              ( \. )
              (
                 [\pL\pM]
                  (?:
                    [\p{Digit}\pL\pM_]  # have alphanum/underscore, or a ' or -
                  |                          # followed by an Alpha or underscore
                    [\-'] [\pL\pM_]
                  )*
          
              )
            )?
            ( \( .*?  \) )
          )?
          REGEX
          'captures' => {
            '1' => {
              'name' => 'variable.other.identifier.sigil.raku'
            },
            '2' => {
              'name' => 'support.class.twigil.interpolated.raku'
            },
            '5' => {
              'patterns' => [
                {
                  'begin' => '<',
                  'beginCaptures' => {
                    '0' => {
                      'name' => 'keyword.operator.chevron.open.raku'
                    }
                  },
                  'end' => '>',
                  'endCaptures' => {
                    '0' => {
                      'name' => 'keyword.operator.chevron.close.raku'
                    }
                  }
                },
                {
                  'begin' => '\\[',
                  'beginCaptures' => {
                    '0' => {
                      'name' => 'keyword.operator.bracket.open.raku'
                    }
                  },
                  'end' => '\\]',
                  'endCaptures' => {
                    '0' => {
                      'name' => 'keyword.operator.bracket.close.raku'
                    }
                  },
                  'patterns' => [
                    {
                      'include' => '$self'
                    },
                  ]
                }
              ]
            },
            '6' => {
              'name' => 'keyword.operator.dot.raku'
            },
            '7' => {
              'name' => 'support.function.raku'
            },
            '8' => {
              'begin' => Q<\(>,
              'beginCaptures' => {
                '0' => {
                  'name' => 'keyword.operator.paren.open.raku'
                }
              },
              'end' => Q<\)>,
              'endCaptures' => {
                '0' => {
                  'name' => 'keyword.operator.paren.close.raku'
                }
              },
              'patterns' => [
                {
                  'include' => '$self'
                },
              ]
            }
          },
          'name' => 'variable.other.identifier.interpolated.raku'
        },
        {
          'include' => '#hex_escapes'
        },
        {
          'include' => '#regexp-variables'
        },
        {
          'begin' => '(?x) (?<! m|rx|m:i|rx:i) (\\{)',
          'beginCaptures' => {
            '1' => {
              'name' => 'punctuation.section.embedded.begin.raku'
            }
          },
          'end' => '(\\})',
          'endCaptures' => {
            '1' => {
              'name' => 'punctuation.section.embedded.end.raku'
            }
          },
          'patterns' => [
            {
              'include' => '$self'
            },
          ],
          'name' => 'meta.interpolation.raku'
        }
      ]
    },
    'q_right_double_right_double_string_content' => {
      'begin' => '”',
      'end' => '”',
      'patterns' => [
        {
          'include' => '#q_right_double_right_double_string_content'
        },
      ]
    }
  }
}
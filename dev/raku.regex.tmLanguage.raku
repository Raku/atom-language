{
  'scopeName' => 'source.regexp.raku',
  'name' => 'Regular Expressions in Raku',
  'fileTypes' => [],
  'patterns' => [
    {
      'include' => '#regexp'
    },
  ],
  'repository' => {
    'regexp' => {
      'patterns' => [
        {
          'begin' => Q/(^[ \t]+)?(?=#)/,
          'beginCaptures' => {
            '1' => {
              'name' => 'punctuation.whitespace.comment.leading.raku'
            }
          },
          'end' => Q/(?!\G)/,
          'patterns' => [
            {
              'begin' => '#',
              'beginCaptures' => {
                '0' => {
                  'name' => 'punctuation.definition.comment.raku'
                }
              },
              'end' => Q/\n/,
              'name' => 'comment.line.number-sign.raku'
            },
          ]
        },
        {
          'include' => '#re_strings'
        },
        {
          'match' => Q/\\[dDhHnNsStTvVwW]/,
          'name' => 'constant.character.escape.class.regexp.raku'
        },
        {
          'match' => Q/:\w+/,
          'name' => 'entity.name.section.adverb.raku'
        },
        {
          'match' => Q/\^\^|(?<!\.)\^(?!\.)|\$\$|\$(?!\d|<)|<<|>>/,
          'name' => 'entity.name.section.boundary.regexp.raku'
        },
        {
          'match' => Q/(?<!\\)\$\d/,
          'name' => 'keyword.other.special-method.match.variable.numbered.perlt6e'
        },
        {
          'match' => Q/(\$)(\<)(\w+)(\>)\s*(=)/,
          'captures' => {
            '1' => {
              'name' => 'variable.other.identifier.sigil.regexp.perl6'
            },
            '2' => {
              'name' => 'support.class.match.name.delimiter.regexp.raku'
            },
            '3' => {
              'name' => 'variable.other.identifier.regexp.perl6'
            },
            '4' => {
              'name' => 'support.class.match.name.delimiter.regexp.raku'
            },
            '5' => {
              'name' => 'storage.modifier.match.assignment.regexp.raku'
            }
          },
          'name' => 'meta.match.variable.raku'
        },
        {
          'begin' => Q/(\<(?:\?|\!)\{)/,
          'beginCaptures' => {
            '1' => {
              'name' => 'punctuation.section.embedded.begin.raku'
            }
          },
          'end' => Q/(\}\>)/,
          'endCaptures' => {
            '1' => {
              'name' => 'punctuation.section.embedded.end.raku'
            }
          },
          'patterns' => [
            {
              'include' => 'source.raku'
            },
          ],
          'name' => 'meta.interpolation.raku'
        },
        {
          'match' => Q/<\(|\)>/,
          'name' => 'keyword.operator.capture.marker.regexp.raku'
        },
        {
          'begin' => Q/(?!\\)</,
          'beginCaptures' => {
            '0' => {
              'name' => 'punctuation.delimiter.property.regexp.raku'
            }
          },
          'end' => '>',
          'endCaptures' => {
            '0' => {
              'name' => 'punctuation.delimiter.property.regexp.raku'
            }
          },
          'name' => 'meta.property.regexp.raku',
          'patterns' => [
            {
              'include' => '#re_strings'
            },
            {
              'begin' => Q/(\?|\!)(before|after)\s+/,
              'beginCaptures' => {
                '1' => {
                  'name' => 'keyword.operator.negativity.raku'
                },
                '2' => {
                  'name' => 'entity.name.section.assertion.raku'
                }
              },
              'end' => '(?=>)',
              'name' => 'meta.assertion.lookaround.raku',
              'patterns' => [
                {
                  'include' => '#regexp'
                },
              ]
            },
            {
              'match' => Q/(\w+)(=)/,
              'captures' => {
                '1' => {
                  'name' => 'entity.name.function.capturename.raku'
                },
                '2' => {
                  'name' => 'storage.modifier.capture.assignment.raku'
                }
              },
              'name' => 'meta.capture.assignment.raku'
            },
            {
              'match' => Q/(:)(\w+)/,
              'captures' => {
                '1' => {
                  'name' => 'punctuation.definition.property.regexp.raku'
                },
                '2' => {
                  'name' => 'variable.other.identifier.property.regexp.raku'
                }
              },
              'name' => 'meta.property.name.regexp.raku'
            },
            {
              'match' => Q/[+|&\-^]/,
              'name' => 'keyword.operator.property.regexp.raku'
            },
            {
              'begin' => Q<\[>,
              'beginCaptures' => {
                '0' => {
                  'name' => 'keyword.operator.charclass.open.regexp.raku'
                }
              },
              'end' => Q/\]/,
              'endCaptures' => {
                '0' => {
                  'name' => 'keyword.operator.charclass.close.regexp.raku'
                }
              },
              'contentName' => 'constant.character.custom.property.regexp.raku',
              'patterns' => [
                {
                  'include' => 'source.raku#hex_escapes'
                },
                {
                  'match' => Q/(?<!\\)\\\]/,
                  'name' => 'constant.character.custom.property.regexp.raku'
                }
              ]
            },
            {
              'match' => Q/\.\w+\b/,
              'name' => 'comment.suppressed.capture.property.regexp.raku'
            },
            {
              'match' => Q/\b\w+\b/,
              'name' => 'variable.other.identifier.regexname.raku'
            },
            {
              'begin' => Q/(?<=\w)\(/,
              'end' => Q/\)/,
              'name' => 'meta.rule.signature.raku',
              'patterns' => [
                {
                  'include' => 'source.raku'
                },
              ]
            }
          ]
        },
        {
          'match' => Q/(?<=\.\.)\*/,
          'name' => 'variable.other.identifier.whatever.regexp.raku'
        },
        {
          'match' => Q/\+|\*\*|\*|\?|%|\.\.|\.|(?<=\.\.|\s|\d)\^/,
          'name' => 'keyword.operator.quantifiers.regexp.raku'
        },
        {
          'match' => Q/(?<!\\)\|{1,2}/,
          'name' => 'support.function.alternation.regexp.raku'
        }
      ]
    },
    're_strings' => {
      'patterns' => [
        {
          'begin' => Q/(?<!\\)\'/,
          'end' => Q/(?<=\\\\)\'|(?<!\\)\'/,
          'name' => 'string.literal.raku'
        },
        {
          'begin' => Q/(?<!\\)‘/,
          'end' => Q/(?<=\\\\)\’|(?<!\\)’/,
          'name' => 'string.literal.raku',
          'patterns' => [
            {
              'include' => 'source.raku#q_left_single_right_single_string_content'
            },
          ]
        },
        {
          'begin' => Q/(?<!\\)\"/,
          'end' => Q/(?<=\\\\)\"|(?<!\\)\"/,
          'name' => 'string.literal.raku'
        }
      ]
    }
  }
}
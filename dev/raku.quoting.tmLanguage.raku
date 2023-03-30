# This file uses two external variables that it can obtain
# from the generator script:
# @*quoting-patterns - the former FIRST.cson
# %*quoting-repo-most - the former SECOND.cson
{
  'scopeName' => 'source.quoting.raku',
  'name' => 'Quoting in Raku',
  'fileTypes' => [],
  'patterns' => @*quoting-patterns,
  'repository' => {
    'qq_character_escape' => {
      'patterns' => [
        {
          'match' => Q/(?x) \\[abtnfre\\\{\}] | \\/,
          'name' => 'constant.character.escape.raku'
        },
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
    },
    |%*quoting-repo-most
  }
}
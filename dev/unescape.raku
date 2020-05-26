#!/usr/bin/env raku
$*IN.slurp-rest.trans([Q<\\>] => Q<\>, Q<\'> => Q<'>).print;

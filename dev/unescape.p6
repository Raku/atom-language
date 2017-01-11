#!/usr/bin/env perl6
$*IN.slurp-rest.trans([Q<\\>] => Q<\>, Q<\'> => Q<'>).print;

#!/usr/bin/env raku
sub escape-cson ( $str is copy ) {
    my @chars = <'>;
    my $reverse-solidus = Q[\];
    $str ~~ s:g/'\\'/$reverse-solidus$reverse-solidus/;
    for @chars -> $char {
        $str ~~ s:g/<!before ｢\\｣> ($char) /$reverse-solidus$0/;
    }
    $str;
}

print escape-cson $*IN.slurp-rest;

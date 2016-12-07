#!/usr/bin/env sh
perl6 ./dev/q-qq-Q-template.p6
awk '
    BEGIN       {p=1}
    /^#1START/   {print;system("cat FIRST.cson");p=0}
    /^#1END/     {p=1}
    p' ./grammars/perl6fe.cson > ./grammars/perl6fe.cson.new
rm FIRST.cson
awk '
    BEGIN       {p=1}
    /^#2START/   {print;system("cat SECOND.cson");p=0}
    /^#2END/     {p=1}
    p' ./grammars/perl6fe.cson.new > ./grammars/perl6fe.cson
rm SECOND.cson
rm ./grammars/perl6fe.cson.new

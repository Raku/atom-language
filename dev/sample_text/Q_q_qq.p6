#!/usr/bin/env perl6
### This is to test the q qq and Q quoting
## any
Q%  $var \t \ \\         { }  \{ \} % $var;
q%  $var \t \ \\ \{{ \}} { }  \{ \} % $var;
qq% $var \t \ \\ \{{ \}} { }  \{ \} % $var;
## {{ }}
Q{{  $var \t \ \\         { }  \{ \} }} $var;
q{{  $var \t \ \\ \{{ \}} { }  \{ \} }} $var;
qq{{ $var \t \ \\ \{{ \}} { }  \{ \} }} $var;
## (( ))
Q((  $var \t \ \\          ( ) \{ \} )) $var;
q((  $var \t \ \\ \(( \))  ( ) \{ \} )) $var;
qq(( $var \t \ \\ \(( \))  ( ) \{ \} )) $var;
## [[ ]]
Q[[  $var \t \ \\         [ ] \{ \}    ]] $var;
q[[  $var \t \ \\ \[[ \]] [ ] \{ \}    ]] $var;
qq[[ $var \t \ \\ \[[ \]] [ ] \{ \}    ]] $var;
## << >>
Q<<  $var \t \ \\                >> $var;
q<<  $var \t \ \\ \<< \>>  \{ \} >> $var;
qq<< $var \t \ \\ \<< \>>  \{ \} >> $var;
## < >
Q< $var \t \ \\                   > $var;
q<  $var \t \ \\ \< \> \{ \}      > $var;
qq< $var $var \t \ \\ \< \> \{ \} > $var;
## { }
Q{  $var \t \ \\             } $var;
q{  $var \t \ \\ \{ \} \{ \} } $var;
qq{ $var \t \ \\ \{ \} \{ \} } $var;
## [ ]
Q[  $var \t \ \\             ] $var;
q[  $var \t \ \\ \[ \] \{ \} ] $var;
qq[ $var \t \ \\ \[ \] \{ \} ] $var;
## ( )
Q (  $var \t \ \\             ) $var;
q (  $var \t \ \\ \( \) \{ \} ) $var;
qq ( $var \t \ \\ \( \) \{ \} ) $var;
## " "
Q"  $var \t \ \\          " $var;
q"  $var \t \ \\ \" \{ \} " $var;
qq" $var \t \ \\ \" \{ \} " $var;
## ' '
Q '  $var \t \ \\    ' $var;
q '  $var \t \ \\ \' ' $var;
qq ' $var \t \ \\ \' ' $var;
## / /
Q/  $var \t \ \\    / $var;
q/  $var \t \ \\ \/ / $var;
qq/ $var \t \ \\ \/ / $var;
## “ ”
Q“  $var \t \ \\       ”
q“  $var \t \ \\ \“ \” ” $var;
qq“ $var \t \ \\ \“ \” ” $var;
## ‘ ’
Q‘  $var \t \ \\       ’ $var;
q‘  $var \t \ \\ \‘ \’ ’ $var;
qq‘ $var \t \ \\ \“ \  ’ $var;

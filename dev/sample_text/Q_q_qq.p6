#!/usr/bin/env perl6
### This is to test the q qq and Q quoting
## {{ }}
Q{{  $var \t \ \\          }}
q{{  $var \t \ \\ \{{ \}}  \{ \} }}
qq{{ $var \t \ \\ \{{ \}}  \{ \} }}
## (( ))
Q((  $var \t \ \\          ))
q((  $var \t \ \\ \(( \))  \{ \} ))
qq(( $var \t \ \\ \(( \))  \{ \} ))
## [[ ]]
Q[[  $var \t \ \\                ]]
q[[  $var \t \ \\ \[[ \]]  \{ \} ]]
q[[ \[[\[ [] \]                ]]
qq[[ $var \t \ \\ \[[ \]] [ ] \{ \} ]]
## << >>
Q<<  $var \t \ \\                >>
q<<  $var \t \ \\ \<< \>>  \{ \} >>
qq<< $var \t \ \\ \<< \>>  \{ \} >>
## < >
Q< $var \t \ \\                   >
q<  $var \t \ \\ \< \> \{ \}      >
qq< $var $var \t \ \\ \< \> \{ \} >
## { }
Q{  $var \t \ \\             }
q{  $var \t \ \\ \{ \} \{ \} }
qq{ $var \t \ \\ \{ \} \{ \} }
## [ ]
Q[  $var \t \ \\               ]
q[  $var \t \ \\ \[ \] \{ \}   ]
qq[ $var \t \ \\ \[ \]  \} ]

## ( )
Q (  $var \t \ \\             )
q (  $var \t \ \\ \( \) \{ \} )
qq ( $var \t \ \\ \( \) \{ \} )
## " "
Q"  $var \t \ \\          "
q"  $var \t \ \\ \" \{ \} "
qq" $var \t \ \\ \" \{ \} "
## ' '
Q '  $var \t \ \\    '
q '  $var \t \ \\ \' '
qq ' $var \t \ \\ \' '
## / /
Q/  $var \t \ \\    /
q/  $var \t \ \\ \/ /
qq/ $var \t \ \\ \/ /

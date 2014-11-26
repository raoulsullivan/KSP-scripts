//sets up PIDvars, direction Units and Off, vectors
PIDvars:add(0.1). //kpr
PIDvars:add(1). //kdr
PIDvars:add(0.1). //kpy
PIDvars:add(1). //kdy
PIDvars:add(0.1). //kpp
PIDvars:add(1). //kdp

set pThresh to 1.
set yThresh to 1.
set rThresh to 1.

//last error inputs
set PIDlasterrors to list().
PIDlasterrors:add(0). //pitch
PIDlasterrors:add(0). //yaw
PIDlasterrors:add(0). //roll

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set vd4 to vecdrawargs(v(0,0,0),v(1,0,0),green,"Relative velocity",10,true).
set PIDvectors to list().
PIDvectors:add(vd0).
PIDvectors:add(vd1).
PIDvectors:add(vd2).
PIDvectors:add(vd3).
PIDvectors:add(vd4).

set dRow to 20.
set dColSpan to 7.
print "      | TAR  | ACT  | ERR  | RAT  | INP  | DEAD" at (0,dRow).
print "ROLL" at (0,dRow+1).
print "PITCH" at (0,dRow+2).
print "YAW" at (0,dRow+3).
//sets up PIDvars, direction Units and Off, vectors
declare parameter kpr. //0.1
declare parameter kdr. //1
declare parameter kpy. //0.1
declare parameter kdy. //1
declare parameter kpp. //0.1
declare parameter kdp. //1
declare parameter pT. //1
declare parameter yT. //1
declare parameter rT.//1

clearscreen.
print "RUNNING PIDSetup".

PIDvars:add(kpr).
PIDvars:add(kdr).
PIDvars:add(kpy).
PIDvars:add(kdy).
PIDvars:add(kpp).
PIDvars:add(kdp).

set pThresh to pT.
set yThresh to yT.
set rThresh to rT.

//last error inputs
set PIDlasterrors to list().
PIDlasterrors:add(0). //pitch
PIDlasterrors:add(0). //yaw
PIDlasterrors:add(0). //roll

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired facing",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set vd4 to vecdrawargs(v(0,0,0),v(0,0,0),green,"Relative velocity",10,true).
set PIDvectors to list().
PIDvectors:add(vd0).
PIDvectors:add(vd1).
PIDvectors:add(vd2).
PIDvectors:add(vd3).
PIDvectors:add(vd4).

print "PIDSetup COMPLETE".
wait 5.
clearscreen.

set dRow to 20.
set dColSpan to 7.
print "      | TAR  | ACT  | ERR  | RAT  | INP  | DEAD" at (0,dRow).
print "ROLL" at (0,dRow+1).
print "PITCH" at (0,dRow+2).
print "YAW" at (0,dRow+3).
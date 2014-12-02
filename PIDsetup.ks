//sets up PIDvars, direction Units and Off, vectors
declare parameter kpr, kdr, kpy, kdy, kpp, kdp, pT, yT, rT.

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired facing",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set vd4 to vecdrawargs(v(0,0,0),v(0,0,0),green,"Relative velocity",10,true).
set vd5 to vecdrawargs(v(0,0,0),v(0,0,0),red,"Desired velocity",10,true).
set PIDvectors to list().
PIDvectors:add(vd0).
PIDvectors:add(vd1).
PIDvectors:add(vd2).
PIDvectors:add(vd3).
PIDvectors:add(vd4).
PIDvectors:add(vd5).

print "RUNNING PIDSetup".
set PIDvars to list().
PIDvars:add(kpr).
PIDvars:add(kdr).
PIDvars:add(kpy).
PIDvars:add(kdy).
PIDvars:add(kpp).
PIDvars:add(kdp).

set pThresh to pT.
set yThresh to yT.
set rThresh to rT.

//launch and initial ascent
//heading locks
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(df:vector,topUnit).
lock yawOff to 90*VDOT(df:vector,starUnit).
lock rollOff to df:roll - ship:facing:roll.

//last error inputs
set PIDlasterrors to list().
PIDlasterrors:add(0). //pitch
PIDlasterrors:add(0). //yaw
PIDlasterrors:add(0). //roll



set dRow to 20.
set dColSpan to 7.
print "      | TAR  | ACT  | ERR  | RAT  | INP  | DEAD" at (0,dRow).
print "ROLL" at (0,dRow+1).
print "PITCH" at (0,dRow+2).
print "YAW" at (0,dRow+3).
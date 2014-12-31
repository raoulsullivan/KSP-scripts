declare parameter kpt, kdt, kps, kds, kpf, kdf.

print "RUNNING PID3Setup".
set PID3vars to list().
PID3vars:add(kpt).
PID3vars:add(kdt).
PID3vars:add(kps).
PID3vars:add(kds).
PID3vars:add(kpf).
PID3vars:add(kdf).

//heading locks
lock topRate to VDOT(relativevelocity,topUnit)*-1.
lock starRate to VDOT(relativevelocity,starUnit)*-1.
lock foreRate to verticalspeed.

//last error inputs
set PID3lasterrors to list().
PID3lasterrors:add(0). //pitch
PID3lasterrors:add(0). //yaw
PID3lasterrors:add(0). //roll

print "TOP" at (0,dRow+5).
print "STAR" at (0,dRow+6).
print "FORE" at (0,dRow+7).
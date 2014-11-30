declare parameter kpt, kdt, kps, kds, kpf, kdf.

print "RUNNING PID2Setup".
set PID2vars to list().
PID2vars:add(kpt).
PID2vars:add(kdt).
PID2vars:add(kps).
PID2vars:add(kds).
PID2vars:add(kpf).
PID2vars:add(kdf).

//heading locks
lock topOff to VDOT(alignposition,topunit).
lock starOff to VDOT(alignposition,starunit).
lock foreOff to VDOT(alignposition,fwdunit).
lock topRate to VDOT(relativevelocity,topUnit)*-1.
lock starRate to VDOT(relativevelocity,starUnit)*-1.
lock foreRate to VDOT(relativevelocity,fwdUnit)*-1.

//last error inputs
set PID2lasterrors to list().
PID2lasterrors:add(0). //pitch
PID2lasterrors:add(0). //yaw
PID2lasterrors:add(0). //roll

print "TOP" at (0,dRow+5).
print "STAR" at (0,dRow+6).
print "FORE" at (0,dRow+7).
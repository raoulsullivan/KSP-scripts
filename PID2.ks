declare parameter toppower, starpower, forepower, useengine.
set PIDvectors[4]:vec to relativevelocity.

set tE to topOff.
set tPP to PID2vars[0] * (abs(tE)^(1/2)) * (abs(tE)/tE).
set tDD to PID2vars[1] * topRate.
set tPID to tPP + tDD.
set tPower to min(toppower,abs(tPID)).
set ship:control:top to tPower * (abs(tPID)/tPID).

set sE to starOff.
set sPP to PID2vars[2] * (abs(sE)^(1/2)) * (abs(sE)/sE).
set sDD to PID2vars[3] * starRate.
set sPID to sPP + sDD.
set sPower to min(starpower,abs(sPID)).
set ship:control:starboard to sPower * (abs(sPID)/sPID).

set fE to foreOff.
set fPP to PID2vars[4] * (abs(fE)^(1/2)) * (abs(fE)/fE).
set fDD to PID2vars[5] * foreRate.
set fPID to fPP + fDD.
set fPower to min(forepower,abs(fPID)).
if useengine {
	lock throttle to fPower.
} else {
	set ship:control:fore to fPower * (abs(fPID)/fPID).
}.

print "0" at (dColSpan,dRow+5).
print "0" at (dColSpan,dRow+6).
print "0" at (dColSpan,dRow+7).
print round(tE,1)+"     " at (dColSpan*2,dRow+5).
print round(sE,1)+"     " at (dColSpan*2,dRow+6).
print round(fE,1)+"     " at (dColSpan*2,dRow+7).
print round(tE,1)+"     " at (dColSpan*3,dRow+5).
print round(sE,1)+"     " at (dColSpan*3,dRow+6).
print round(fE,1)+"     " at (dColSpan*3,dRow+7).
print round(topRate,1)+"     " at (dColSpan*4,dRow+5).
print round(starRate,1)+"     " at (dColSpan*4,dRow+6).
print round(foreRate,1)+"     " at (dColSpan*4,dRow+7).
print round(ship:control:top,1)+"     " at (dColSpan*5,dRow+5).
print round(ship:control:starboard,1)+"     " at (dColSpan*5,dRow+6).
print round(ship:control:fore,1)+"     " at (dColSpan*5,dRow+7).
print round(forepower,1)+"     " at (dColSpan*5,dRow+12).
print round(fPID,1)+"     " at (dColSpan*5,dRow+13).
print round(fPower,1)+"     " at (dColSpan*5,dRow+14).
print round(throttle,1)+"     " at (dColSpan*5,dRow+15).
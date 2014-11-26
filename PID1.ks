//declare parameter PIDVars.
//declare parameter pitchOff.
//declare parameter yawOff.
//declare parameter rollOff.
//declare parameter PIDLastErrors.
//declare parameter PIDvectors.
declare parameter pitchpower.
declare parameter yawpower.
declare parameter rollpower.

set PIDvectors[0]:vec to dF:vector.
set PIDvectors[1]:vec to starUnit.
set PIDvectors[2]:vec to topUnit.
set PIDvectors[3]:vec to fwdUnit.

set kpr to PIDvars[0].
set kdr to PIDvars[1].
set kpy to PIDvars[2].
set kdy to PIDvars[3].
set kpp to PIDvars[4].
set kdp to PIDvars[5].

set lPE to PIDLastErrors[0].
set pE to pitchOff.
set PIDLastErrors[0] to pE.
if pE > 180 {set pE to (360 - pE) * -1.}.
if pE < -180 {set pE to (360 + pE).}.
if abs(pE) < pThresh and (abs(pE - lPE) < (pThresh/10)) { set pDZ to 0.} else {set pDZ to 1.}.
set ship:control:pitch to pitchpower * pDZ * ((kpp * abs(pE)^1/3 * (abs(pE)/pE)) + (kdp*(pE - lPE))).

set lYE to PIDLastErrors[1].
set yE to yawOff.
set PIDLastErrors[1] to yE.
if yE > 180 {set yE to (360 - yE) * -1.}.
if yE < -180 {set yE to (360 + yE).}.
if abs(yE) < yThresh and (abs(yE - lYE) < (yThresh/10)) { set yDZ to 0.} else {set yDZ to 1.}.
set ship:control:Yaw to yawpower * yDZ * ((kpy * abs(yE)^1/3 * (abs(yE)/yE)) + (kdy * (yE - lYE))).

set lRE to PIDLastErrors[2].
set rE to rollOff.
set PIDLastErrors[2] to rE.
if rE > 180 {set rE to (360 - rE) * -1.}.
if rE < -180 {set rE to (360 + rE).}.
if abs(rE) < rThresh and (abs(rE - lRE) < (rThresh/10)) { set rDZ to 0.} else {set rDZ to 1.}.
set ship:control:roll to -rollpower * rDZ * ((kpr * abs(rE)^1/3 * (abs(rE)/rE))+(kdr*(rE - lRE))).

if (pDZ + yDZ + rDZ) = 0 {set onTarget to true.} else {set onTarget to false.}.

print round(dF:roll,1)+"     " at (dColSpan,dRow+1).
print round(dF:pitch,1)+"     " at (dColSpan,dRow+2).
print round(dF:yaw,1)+"     " at (dColSpan,dRow+3).
print round(ship:facing:roll,1)+"     " at (dColSpan*2,dRow+1).
print round(ship:facing:pitch,1)+"     " at (dColSpan*2,dRow+2).
print round(ship:facing:yaw,1)+"     " at (dColSpan*2,dRow+3).
print round(rE,1)+"     " at (dColSpan*3,dRow+1).
print round(pE,1)+"     " at (dColSpan*3,dRow+2).
print round(yE,1)+"     " at (dColSpan*3,dRow+3).
print round(rE - lRE,1)+"     " at (dColSpan*4,dRow+1).
print round(pE - lPE,1)+"     " at (dColSpan*4,dRow+2).
print round(yE - lYE,1)+"     " at (dColSpan*4,dRow+3).
print round(ship:control:roll,1)+"     " at (dColSpan*5,dRow+1).
print round(ship:control:pitch,1)+"     " at (dColSpan*5,dRow+2).
print round(ship:control:yaw,1)+"     " at (dColSpan*5,dRow+3).
print rDZ at (dColSpan*6,dRow+1).
print pDZ at (dColSpan*6,dRow+2).
print yDZ at (dColSpan*6,dRow+3).
print "On target: "+onTarget+" " at (0,dRow+5).
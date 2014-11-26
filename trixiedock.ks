//docks?!
clearscreen.
set rcsthrusters to 8.
set aligndistance to 25.

lock dockingportvector to target:facing:vector.
lock alignposition to (dockingportvector * aligndistance) + target:position.

lock relativevelocity to ship:velocity:orbit - target:velocity:orbit.

set maxapproachspeed to 2.
set approachdistmod to 50.
set maxheadspeed to 1.
set headerrmod to 45.
set headerpower to 0.2.

//lock dF to alignposition:direction.

//when alignposition:mag < 1 then {
	lock dF to dockingportvector:direction.
	lock totalerror to abs(rE) + abs(pE) + abs(yE).
	lock te2 to max(0,totalerror - 10).
	lock translationpower to max(0,0.2-te2).
	lock alignposition to dockingportvector+v(-50,10,0) + target:position.
	set rollcontrol to true.
	when alignposition:mag < 0.5 then {
		print "Final approach". 
		lock alignposition to target:position.
		when alignposition:mag < 0.5 then {
			rcs off.
		}.
	}.
//}.

when alignposition:mag < 1 then {
	toggle ag5.
	stage.
	lock alignposition to (dockingportvector*15) + target:position.
}.


set maxtranslationerror to 3.
//set translationpower to 0.2.
set approachdirection to 1.
set rollcontrol to true.
set step to "Align".
rcs on.
set kpr to 0.01.
set kdr to 1.
set kpy to 0.1.
set kdy to 1.
set kpp to 0.1.
set kdp to 1.
set kpt to 0.1.
set kdt to 1.
set kps to 0.1.
set kds to 1.
set kpf to 0.1.
set kdf to 1.
set er to 0.
set ep to 0.
set ey to 0.
set rE to 0.
set pE to 0.
set yE to 0.
set tE to 0.
set sE to 0.
set fE to 0.
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(dF:vector,topUnit).
lock yawOff to 90*VDOT(dF:vector,starUnit).
lock rotOff to dF:roll - ship:facing:roll.
//this is meters DOWN the z-axis.
//pressing I increases this
lock topOff to VDOT(alignposition,topunit).
//this is meters ALONG the x-axis
//pressing l increases this
lock starOff to VDOT(alignposition,starunit).
lock foreOff to VDOT(alignposition,fwdunit).
lock topRate to VDOT(relativevelocity,topUnit)*-1.
lock starRate to VDOT(relativevelocity,starUnit)*-1.
lock foreRate to VDOT(relativevelocity,fwdUnit)*-1.

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set vd4 to vecdrawargs(v(0,0,0),v(1,0,0),green,"Relative velocity",10,true).
set lastroll to ship:facing:roll.
print "     | TAR | ACT | ERR | INP" at (0,20).
print "ROLL" at (0,21).
print "PITCH" at (0,22).
print "YAW" at (0,23).
print "TOP" at (0,25).
print "STAR" at (0,26).
print "FORE" at (0,27).
print "TRATE" at (0,29).
print "SRATE" at (0,30).
print "FRATE" at (0,31).
until step = "Done" {
	set vd0:vec to dF:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	set vd4:vec to relativevelocity.
	
	set lRE to rE.
	set rE to rotOff.
	if rE > 180 {set rE to (360 - rE) * -1.}.
	if rE < -180 {set rE to (360 + rE).}.
	if rollcontrol {	set ship:control:roll to -1*((kpr * rE)+(kdr*(rE - lRE))). } else {	set ship:control:roll to 0. }.
	
	set lPE to pE.
	set pE to pitchOff.
	//set dPitchRate to (abs(pitchOff)/pitchOff) * -min((abs(pitchOff)/headerrmod),maxheadspeed).
	//set pRE to (pE - lPE) - dPitchRate.
	//set pPower to min(headerpower,abs(pRE)).
	//set ship:control:pitch to (abs(pRE)/pRE) * pPower.
	
	if pE > 180 {set pE to (360 - pE) * -1.}.
	if pE < -180 {set pE to (360 + pE).}.
	if abs(pE) < 0.5 {set pDZ to 0.} else {set pDZ to 1.}.
	set ship:control:pitch to pDZ * ((kpp * abs(pE)^1/3 * (abs(pE)/pE)) + (kdp*(pE - lPE))).
	
	set lYE to yE.
	set yE to yawOff.
	
	//set dYawRate to (abs(yawOff)/yawOff) * -min((abs(yawOff)/headerrmod),maxheadspeed).
	//set pYE to (yE - lYE) - dYawRate.
	//set yPower to min(headerpower,abs(pYE)).
	//set ship:control:yaw to (abs(pYE)/pYE) * yPower.	
	
	if yE > 180 {set yE to (360 - yE) * -1.}.
	if yE < -180 {set yE to (360 + yE).}.
	if abs(yE) < 0.5 {set yDZ to 0.} else {set yDZ to 1.}.
	set ship:control:Yaw to yDZ * ((kpy * abs(yE)^1/3 * (abs(yE)/yE)) + (kdy * (yE - lYE))).
	
	set lTE to tE.
	set tE to topOff.
	lock tRate to topRate.
	set tDZ to 1.
	//if abs(tE) < 0.5 {set tDZ to 0.} else {set tDZ to 1.}.
	//as tE increases, tPP should increase
	set tPP to kpt * (abs(tE)^(1/3)) * (abs(tE)/tE).
	//as tRate increases, tDD should increase. it should offset tPP if in the right direction.
	set tDD to kdt * tRate.
	set tPID to tPP + tDD.
	set tPower to min(translationpower,abs(tPID)).
	set ship:control:top to tPower * tDZ * (abs(tPID)/tPID).
	//set ship:control:top to 0.1.
	
	//set tT to abs(tE)/tE.
	//if abs(tE) < 0.1 { set tE to 0. }.
	//set dTopRate to tT * -min(abs(tE)/approachdistmod,maxapproachspeed).
	//set tRE to topRate-dTopRate.
	//set tPower to min(translationpower,abs(tRE)).
	//set ship:control:top to (abs(tRE)/tRE) * tPower.
	
	print ROUND(tPP,5) at (0,4).
	print ROUND(tDD,5) at (0,5).
	print ROUND(tPID,5) at (0,6).
	print ROUND(tPower,5) at (0,7).
	
	set lSE to sE.
	set sE to starOff.
	lock sRate to starRate.
	set sDZ to 1.
	//if abs(sE) < 0.5 {set sDZ to 0.} else {set sDZ to 1.}.
	set sPP to kps * (abs(sE)^(1/3)) * (abs(sE)/sE).
	set sDD to kds * sRate.
	set sPID to sPP + sDD.
	set sPower to min(translationpower,abs(sPID)).
	set ship:control:starboard to sPower * sDZ * (abs(sPID)/sPID).

	print ROUND(sPP,5) at (12,4).
	print ROUND(sDD,5) at (12,5).
	print ROUND(sPID,5) at (12,6).
	print ROUND(sPower,5) at (12,7).	
	
	set lFE to fE.
	set fE to foreOff.
	lock fRate to foreRate.
	set fDZ to 1.
	//if abs(fE) < 0.5 {set fDZ to 0.} else {set fDZ to 1.}.
	set fPP to kpf * (abs(fE)^(1/3)) * (abs(fE)/fE).
	set fDD to kdf * fRate.
	set fPID to fPP + fDD.
	set fPower to min(translationpower,abs(fPID)).
	set ship:control:fore to fPower * fDZ * (abs(fPID)/fPID).

	print ROUND(fPP,5) at (24,4).
	print ROUND(fDD,5) at (24,5).
	print ROUND(fPID,5) at (24,6).
	print ROUND(fPower,5) at (24,7).	
	
	print round(dF:roll,2)+"     " at (6,21).
	print round(dF:pitch,2)+"     " at (6,22).
	print round(dF:yaw,2)+"     " at (6,23).
	print round(ship:facing:roll,2)+"     " at (12,21).
	print round(ship:facing:pitch,2)+"     " at (12,22).
	print round(ship:facing:yaw,2)+"     " at (12,23).
	print round(rE,2)+"     " at (18,21).
	print round(pE,2)+"     " at (18,22).
	print round(yE,2)+"     " at (18,23).
	print round(ship:control:roll,2)+"     " at (24,21).
	print round(ship:control:pitch,2)+"     " at (24,22).
	print round(ship:control:yaw,2)+"     " at (24,23).

	
	print round(tE,2)+"     " at (18,25).
	print round(sE,2)+"     " at (18,26).
	print round(fE,2)+"     " at (18,27).

	//print round(dTopRate,2)+"     " at (6,29).
	//print round(dStarRate,2)+"     " at (6,30).
	//print round(dForeRate,2)+"     " at (6,31).
	print round(tRate,2)+"     " at (12,29).
	print round(starRate,2)+"     " at (12,30).
	print round(foreRate,2)+"     " at (12,31).
	//print round(tRE,2)+"     " at (18,29).
	//print round(tSE,2)+"     " at (18,30).
	//print round(tFE,2)+"     " at (18,31).
	print round(ship:control:top,2)+"     " at (24,29).
	print round(ship:control:starboard,2)+"     " at (24,30).
	print round(ship:control:fore,2)+"     " at (24,31).
	print totalerror at (0,0).
	//print te2 at (0,1).
	print translationpower at (0,2).
	wait 0.1.
}.
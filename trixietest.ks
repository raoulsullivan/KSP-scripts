set bd to ship:obt:body.
set thrust to 8.
set isp to 260.
set desiredalt to 80000.
set k to constant():g * bd:mass.
lock a to ship:obt:semimajoraxis.
set rollcontrol to true.
//lock tH to ship:prograde + R(90,0,0).
//lock tH to ship:prograde + R(0,0,0).
//lock tH to ship:prograde + R(0,180,0).
lock tH to ship:prograde + R(75,75,0).
//things
set minerror to 1.
set maxerror to 10.
set kpr to 0.001.
set kdr to 0.1.
set kpy to 0.001.
set kdy to 0.1.
set kpp to 0.001.
set kdp to 0.1.
set er to 0.
set ep to 0.
set ey to 0.
set rE to 0.
set pE to 0.
set yE to 0.
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rotOff to 90*VDOT(tH:vector,fwdUnit).
set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set lastroll to ship:facing:roll.
set rotcontrol to true.

until 0 {
	clearscreen.
	print ("         | TAR | ACT | ERR | INP ") at (0,0).
	print ("ROLL:") at (0,1).
	print ("YAW:") at (0,2).
	print ("PITCH:") at (0,3).
	print ("---- VECTORS ----") at (0,5).
	print ("TARGET") at (0,7).
	print ("FACING") at (0,11).
	print ("ERROR") at (0,15).
	set vd0:vec to tH:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	
	print round(th:roll)+"  " at (11,1).
	print round(th:yaw)+"  " at (11,2).
	print round(th:pitch)+"  " at (11,3).
	
	print "ROLL: "+(th:vector:z) at (0,8).
	print "YAW:  "+(th:vector:x) at (0,9).
	print "PITCH:"+(th:vector:y) at (0,10).
	
	print round(facing:roll)+"  " at (17,1).
	print round(facing:yaw)+"  " at (17,2).
	print round(facing:pitch)+"  " at (17,3).

	print "ROLL: "+(facing:vector:z) at (0,12).
	print "YAW:  "+(facing:vector:x) at (0,13).
	print "PITCH:"+(facing:vector:y) at (0,14).
	
	set lRE to rE.
	set rE to tH:roll - ship:facing:roll.
	if rE > 180 {set rE to (360 - rE) * -1.}.
	if rE < -180 {set rE to (360 + rE).}.
	if rotcontrol {	set ship:control:roll to -1*((kpr * rE)+(kdr*(rE - lRE))). } else {	set ship:control:roll to 0. }.
	
	set lPE to pE.
	set pE to pitchOff.
	if pE > 180 {set pE to (360 - pE) * -1.}.
	if pE < -180 {set pE to (360 + pE).}.
	set ship:control:pitch to ((kpp * pE)+(kdp*(pE - lPE))).
	
	set lYE to yE.
	set yE to yawOff.
	if yE > 180 {set yE to (360 - yE) * -1.}.
	if yE < -180 {set yE to (360 + yE).}.
	
	set ship:control:Yaw to ((kpy * yE)+(kdy*(yE - lYE))).

	print round(ship:control:roll,2)+"  " at (29,1).
	print round(ship:control:pitch,2)+"  " at (29,2).
	print round(ship:control:yaw,2)+"  " at (29,3).

	print round(rE)+"  " at (23,1).
	print round(yE)+"  " at (23,2).
	print round(pE)+"  " at (23,3).
	print rotOff at (0,25).
	print (rE)+"  " at (0,16).
	print (yE)+"  " at (0,17).
	print (pE)+"  " at (0,18).
	
	wait 0.1.
}.
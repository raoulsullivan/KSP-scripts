set bd to ship:obt:body.
set thrust to 8.
set isp to 260.
//set thrust to ship:maxthrust.
//set isp to 350.
set desiredalt to 80000.
set k to constant():g * bd:mass.
lock a to ship:obt:semimajoraxis.

set correct to false.
set rollcontrol to true.

//on correct {
	//velocity at next node
	lock tH to ship:prograde+ R(0,0,0).

	//preserve.
	set nxt to ship:apoapsis. set nexteta to eta:apoapsis.
	if eta:periapsis < eta:apoapsis {set nxt to ship:periapsis. set nexteta to eta:periapsis.}.
	set r to nxt + bd:radius.
	set desireda to (r + desiredalt + bd:radius) / 2.
	set v to sqrt(k*((2/r) - (1/a))).
	set desiredv to sqrt(k*((2/r) - (1/desireda))).
	set dv to desiredv - v.
	print ("DeltaV: "+dv).

	//set
	set x to node (time:seconds+nexteta,0,0,dv).
	add x.

	set thrustpower to 0.5.
	set mfinal to ship:mass/(constant():e^(abs(dv)/(isp * 9.8066))).
	print("Mass after burn: "+mfinal).
	set mchange to (ship:mass - mfinal) * 1000.
	print("Mass change: "+mchange).
	set mdot to thrust*thrustpower*1000/(isp * 9.8066).
	set burntime to mchange/mdot.
	print("Burn time: "+burntime).
	set burnstart to x:eta+time - (burntime/2).
	print("Burn start: "+burnstart).
	set burnstop to burnstart + burntime.
	set timetoburn to time - burnstart.
	print("Time to burn: "+timetoburn).
	set warp to 3.
	when time >= burnstart-90 then {set warp to 0.}.
	when time >= burnstart-60 then {set step to "Align". Toggle RCS.}.
	when time >= burnstart then {set step to "Thrust". set tp to thrustpower. if dv < 0 {set tp to tp * -1.}. set ship:control:fore to tp.}.
	when time >= burnstop then {
		set step to "Next". set ship:control:fore to 0. toggle RCS.
		remove x.
		//trigger second burn
		set correct to false.
	}.
//}.

set correct to true.

//things
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
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rotOff to 90*VDOT(tH:vector,fwdUnit).
lock rotOff to tH:roll - ship:facing:roll.
set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set lastroll to ship:facing:roll.

until 0 {
	set vd0:vec to tH:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.

	set lRE to rE.
	set rE to rotOff.
	if rE > 180 {set rE to (360 - rE) * -1.}.
	if rE < -180 {set rE to (360 + rE).}.
	if rollcontrol {	set ship:control:roll to -1*((kpr * rE)+(kdr*(rE - lRE))). } else {	set ship:control:roll to 0. }.
	
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
	
	wait 0.1.
}.
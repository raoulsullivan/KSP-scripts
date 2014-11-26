set step to "Wait for node".
set kpr to 0.01.
set kdr to 0.1.
set kpy to 0.01.
set kdy to 0.1.
set kpp to 0.01.
set kdp to 0.1.

//errors for derivatives
set er to 0.
set ep to 0.
set ey to 0.

//initial errors
set rE to 0.
set pE to 0.
set yE to 0.

//heading locks
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rotOff to 90*VDOT(tH:vector,fwdUnit).

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).

//calculate transfer time and required DV
set bd to body("Kerbin").
set target to body("mun").
set u to (constant():g*bd:mass).
set currentradius to ship:obt:apoapsis + bd:radius.
set targetradius to target:obt:apoapsis + bd:radius.
set targetsma to (targetradius + bd:radius + currentradius) / 2.
set xfertime to ((2*constant():pi)*sqrt((targetsma^3)/(constant():g*bd:mass)))/2.
print (xfertime/60).
set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/(ship:obt:semimajoraxis + ((target:obt:apoapsis - ship:periapsis)/2))))).
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
set desireddv to desiredvelocityatap -currentvelocityatap.
print(desireddv).

//calculate current phase angle
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print ("Phase angle: "+phaseangle).


lock xferoffset to mod(((xfertime/target:obt:period)*360),360).
set departurediff to phaseangle - (180-xferoffset).
if (departurediff < 0) {set departurediff to 360+departurediff.}.
print ("Departure diff: "+departurediff).
set timetoxfer to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer).
set waitingoffset to mod(((timetoxfer/target:obt:period)*360),360).
set departurediff to departurediff + waitingoffset.
print ("Departure diff: "+departurediff).
set timetoxfer2 to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer2).
set x to node (time:seconds+timetoxfer2,0,0,desireddv).
add x.

lock tH to x:BURNVECTOR:DIRECTION+ R(0,0,90).

set isp to 380.
set mfinal to ship:mass/(constant():e^(desireddv/(isp * 9.8066))).
set mchange to (ship:mass - mfinal) * 1000.
set mdot to ship:maxthrust*1*1000/(isp * 9.8066).
set burntime to mchange/mdot.
print("Burn time: "+burntime) at(0,10).
set burnstart to x:eta+time - (burntime/2).
print("Burn start: "+burnstart) at(0,11).
set burnstop to burnstart + burntime.
print("Burn stop: "+burnstop) at(0,12).
set timetoburn to time - burnstart.
when time >= burnstart-60 then {set step to "Align". Toggle RCS.}.
when time >= burnstart then {
	set step to "Injection burn".
	lock throttle to 1. 
	when time >= burnstop then {
		lock tH to ship:prograde + R(0,0,180).
		lock throttle to 0.1.
		when (ship:apoapsis + bd:radius) >= targetradius then {
			lock throttle to 0.
			set step to "On target".
			set p to ship:obt:patches.
			if p[1]:body <> body("Mun") {
				set step to "MISSED :(".
			}.
			else {
				if p[1]:periapsis > 45000 {
					set ship:control:fore to 1.
					when p[1]:periapsis <= 45000 then {set ship:control:fore to 0. toggle rcs. set step to "Done".}.
				}.
				else {
					set ship:control:fore to -1.
					when p[1]:periapsis >= 45000 then {set ship:control:fore to 0. toggle rcs. set step to "Done".}.
				}.
			}.
		}.
	}.
}.

until 0 {
	print (step) at (0,0).
	set vd0:vec to tH:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.

	set rTarget to tH:Roll - 180.
	set lRE to rE.
	set rE to ship:facing:Roll - rTarget.
	if rE > 180 {set rE to (360 - rE)* -1.}.
	set ship:control:roll to (kpr * rE)+(kdr*(rE - lRE)).
	
	set lPE to pE.
	set pE to pitchOff.
	if pE > 180 {set pE to (360 - pE) * -1.}.
	set ship:control:pitch to (kpp * pE)+(kdp*(pE - lPE)).
	
	set lYE to yE.
	set yE to yawOff.
	if yE > 180 {set yE to (360 - yE) * -1.}.
	set ship:control:Yaw to (kpy * yE)+(kdy*(yE - lYE)).
	
	wait 0.1.
}.

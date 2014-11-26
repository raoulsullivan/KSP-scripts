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

lock orbitalcompletion to ship:obt:MEANANOMALYATEPOCH/(2*constant():pi).
lock timetoperiapse to (ship:obt:period*(1-(orbitalcompletion))).
lock orbitalcompletion2 to 0.5+orbitalcompletion-floor(orbitalcompletion/0.51).
lock timetoapoapse to (ship:obt:period*(1-(orbitalcompletion2))).

set bd to body("Kerbin").
set target to body("mun").

lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + (orbitalcompletion*360)),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
lock phaseangle to 360-abs(targetpos-shippos).
lock tH to ship:prograde.


lock currentradius to ship:obt:apoapsis + bd:radius.

set deltavavailable to 850.
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
print("Current velocity at AP: "+currentvelocityatap) at(0,16).
set newvelocityatap to currentvelocityatap+deltavavailable.
print("New velocity at AP: "+newvelocityatap) at(0,17).
set u to (constant():g*bd:mass).
set newsma to (u / (2* ((newvelocityatap^2/2)-(u/currentradius))))*-1.
print("New SMA after "+deltavavailable+" dv: "+round(newsma)) at(0,15).
set newalt to (newsma*2)-currentradius-bd:radius.
print("New Alt after: "+newalt) at(0,18).

lock targetradius to target:obt:apoapsis + bd:radius.

lock targetsma to (targetradius + bd:radius + currentradius) / 2.
lock currentsma to ship:obt:semimajoraxis.
lock xfertime to ((2*constant():pi)*sqrt((targetsma^3)/(constant():g*bd:mass)))/2.
lock xferoffset to mod(((xfertime/target:obt:period)*360),360).
lock xferangle to 0 + xferoffset.
lock xferoffset2 to phaseangle - (180-xferangle).
lock timetoxfer to ship:obt:period*(xferoffset2/360).

set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/(ship:obt:semimajoraxis + ((target:obt:apoapsis - ship:periapsis)/2))))).
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
set desireddv to desiredvelocityatap -currentvelocityatap.

set x to node (time:seconds+timetoxfer,0,0,desireddv).
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
when time >= burnstart-30 then {set step to "Align". Toggle RCS.}.
when time >= burnstart then {
	set step to "Injection burn".
	lock throttle to 1. 
	when time >= burnstop then {
		lock throttle to 0.
		Toggle RCS.
		set step to "Coast".
	}.
}.

until 0 {
	print (step) at (0,0).
	print (round(ship:obt:lan)+" + "+ round(ship:obt:argumentofperiapsis)+" + " + round((orbitalcompletion*360))+" = " + shippos) at (0,1).
	print (round(target:obt:lan)+" + "+ round(target:obt:argumentofperiapsis)+" + " + round(target:obt:trueanomaly)+" = " + targetpos) at (0,2).
	print ("Current phase angle: "+round(phaseangle)) at (0,3).
	print ("Transfer time: "+round(xfertime/60)) at (0,4).
	print ("Movement of target in this time: "+round(xferoffset)) at (0,5).
	print ("Current position to burn point: "+round(xferoffset2)) at (0,7).
	print ("Time to burn point: "+round(timetoxfer)) at (0,8).
	print ("Desired DV: "+round(desireddv)) at (0,9).
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

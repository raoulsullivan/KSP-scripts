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

set bd to body("mun").
set u to (constant():g*bd:mass).
set per to ship:obt:periapsis.

//calculate SMA - oh wait, we don't have to!
set sma to ship:obt:SEMIMAJORAXIS.
set ecc to ship:obt:ECCENTRICITY.

//calculate orbital velocity for circular orbit
set desiredvelocityatpe to sqrt(u*((2/per)-(1/per))).
print ("Desired velocity at PE: "+desiredvelocityatpe).

//calculate current velocity
set currentvelocityatpe to ((-u/sma)*(1+ecc)/(ecc-1))^(1/2).
print ("Current velocity at PE: "+currentvelocityatpe).

// a different way
set ecc to ship:obt:ECCENTRICITY.
set slr to sma*(1-ecc^2).
set currentvelocityatpe2 to sqrt((u/slr)*(1 + ecc^2 - (2*cos(0)))).
print ("Current velocity at PE2: "+currentvelocityatpe2).

set desireddv to -currentvelocityatpe2.

//node
set x to node (time:seconds+eta:periapsis,0,0,desireddv).
add x.

lock tH to x:BURNVECTOR:DIRECTION+ R(0,0,90).

set isp to 380.
set mfinal to ship:mass/(constant():e^(abs(desireddv)/(isp * 9.8066))).
set mchange to (ship:mass - mfinal) * 1000.
set mdot to ship:maxthrust*1*1000/(isp * 9.8066).
set burntime to mchange/mdot.
print("Burn time: "+burntime).
set burnstart to x:eta+time - (burntime/2).
print("Burn start: "+burnstart).
set burnstop to burnstart + burntime.
print("Burn stop: "+burnstop).
set timetoburn to time - burnstart.
when time >= burnstart-30 then {set step to "Align". Toggle RCS.}.
when time >= burnstart then {
	set step to "Injection burn".
	lock throttle to 1. 
	when time >= burnstop then {
		lock throttle to 0.
		set step to "Done".
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

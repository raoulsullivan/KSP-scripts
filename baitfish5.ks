//pid multipliers
set kp to 0.5.
set kd to 0.1.
set kpr to 0.05.
set kdr to 0.05.
set kpy to 0.1.
set kdy to 0.1.
set kpp to 0.1.
set kdp to 0.1.

//errors for derivatives
set et to 0.
set er to 0.
set ep to 0.
set ey to 0.

//initial errors
set rE to 0.
set pE to 0.
set yE to 0.

//maximal errors allowed
set maxET to 10.
set maxEP to 10.
set maxEY to 10.
set maxER to 10.

//base throttle
set bd to body("kerbin").
lock heregrav to constant():G*bd:mass/((altitude+bd:radius)^2).
lock gravforce to mass*heregrav.
lock TWR to (max(ship:maxthrust,0.001) / gravforce).
lock bT to (1/TWR).

//heading locks
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rotOff to 90*VDOT(tH:vector,fwdUnit).

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"starUnit",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"topUnit",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"fwdUnit",4,true).

lock orbitalcompletion to ship:obt:MEANANOMALYATEPOCH/(2*constant():pi).
lock timetoperiapse to (ship:obt:period*(1-(orbitalcompletion))).
lock orbitalcompletion2 to 0.5+orbitalcompletion-floor(orbitalcompletion/0.51).
lock timetoapoapse to (ship:obt:period*(1-(orbitalcompletion2))).


//control variables
set tA1 to 8000. //grav turn
set tA2 to 80000. //final alt
set tInc to 0. //inclination of final orbit

//speed
lock tV to ship:termvelocity.
lock aV to velocity:surface:mag.

lock lat to ship:geoposition:lat.
set tOV to sqrt((constant():G*bd:mass)/(bd:radius + tA2)).

//step 1 - Ascent
set tH to heading(tInc,90)+ R(0,0,180).
set step to "Ascent".
lock throttle to 1.
clearscreen.
stage.
set starttime to time:seconds.
when time:seconds > starttime+10 then {lock throttle to 0.8.}.

//step 2 - gravity turn
when altitude > tA1 then {set step to "Gravity turn". lock tH to heading(tInc,90-(sqrt(altitude/tA2)*90))+ R(0,0,180).}.
when altitude > 25001 then {
	toggle RCS.
}.

//step 2 - coast
when ship:apoapsis >= tA2 then {
	set step to "Coast".
	set kpr to 0.01.
	set kdr to 0.5.
	set kpy to 0.01.
	set kdy to 0.5.
	set kpp to 0.01.
	set kdp to 0.5.
	lock throttle to 0. 
	lock aV to velocity:orbit:mag.
	lock tH to ship:prograde+ R(0,0,180).
	set currentaltrad to ship:apoapsis + bd:radius.
	set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/(ship:obt:semimajoraxis + ((tA2 - ship:periapsis)/2))))).
	set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/ship:obt:semimajoraxis))).
	set desireddv to desiredvelocityatap -currentvelocityatap.
	set x to node (time:seconds+timetoapoapse,0,0,desireddv).
	add x.
	list engines in enginelist.
	set isp to 360.
	set mfinal to ship:mass/(constant():e^(desireddv/(isp * 9.8066))).
	set mchange to (ship:mass - mfinal) * 1000.
	set mdot to ship:maxthrust*0.8*1000/(isp * 9.8066).
	set burntime to mchange/mdot.
	print("Burn time: "+burntime) at(0,1).
	set burnstart to x:eta+time - (burntime/2).
	print("Burn start: "+burnstart) at(0,2).
	set burnstop to burnstart + burntime.
	print("Burn stop: "+burnstop) at(0,3).
	lock timetoburn to time - burnstart.
	when time >= burnstart then {
		lock throttle to 0.8. 
		when time >= burnstop then {
			lock throttle to 0.
			toggle RCS.
			set step to "Science! Shore next...".
			clearscreen.
			when lat > 64.8 then {
				toggle AG1.
				set step to "Science! Ice next...".
				when lat > 81 then {
					toggle AG1.
					set step to "Science! Tundra next...".
					when lat < 77 then {
						toggle AG1.
						toggle RCS.
					}.
				}.
			}.
		}.
	}.
	
	
}.

when stage:liquidfuel <= 1 then {
	wait 1.
	stage.
}.

until 0 {
	print (step) at (0,0).
	print (lat) at (20,0).
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

//pid multipliers
set kpr to 0.05.
set kdr to 0.05.
set kpy to 0.1.
set kdy to 0.1.
set kpp to 0.1.
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

set bd to body("Kerbin").

//control variables
set tA1 to 8000. //grav turn
set tA2 to 80000. //final alt
set tInc to 90. //inclination of final orbit

//speed
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
when time:seconds > starttime+10 then {lock throttle to 0.7.}.
when time:seconds > starttime+30 then {lock throttle to 0.8.}.
//step 2 - gravity turn
when altitude > tA1 then {set step to "Gravity turn". lock tH to heading(tInc,90-(sqrt(altitude/tA2)*90))+ R(0,0,180).}.
when altitude > 15001 then {
	toggle RCS.
}.
when altitude > 50000 then {
	toggle AG1.
	toggle AG2.
}.

//step 2 - coast
when ship:apoapsis >= tA2 then {
	lock throttle to 0.
	set step to "Coast".
	toggle rcs.
	when ship:altitude > 70500 then {
		stage.
		toggle rcs.
		set kpr to 0.01.
		set kdr to 0.5.
		set kpy to 0.01.
		set kdy to 0.5.
		set kpp to 0.01.
		set kdp to 0.5.
		lock aV to velocity:orbit:mag.
		
		set currentaltrad to ship:apoapsis + bd:radius.
		set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/(ship:obt:semimajoraxis + ((tA2 - ship:periapsis)/2))))).
		set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/ship:obt:semimajoraxis))).
		set desireddv to desiredvelocityatap -currentvelocityatap.
		set x to node (time:seconds+timetoapoapse,0,0,desireddv).
		add x.
		lock tH to x:BURNVECTOR:DIRECTION+ R(0,0,90).

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
		
		set timetoburn to time - burnstart.	
		when time >= burnstart then {
			set step to "Circularise".
			lock throttle to 0.8. 
			when time >= burnstop then {
				lock throttle to 0.
				when time >= (burnstop + 5) then {
					stage.
					toggle RCS.
					toggle AG9.
					lock tH to prograde+ R(0,0,180).
					set step to "Launch complete".
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

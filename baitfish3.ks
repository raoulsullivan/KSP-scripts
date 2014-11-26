//pid multipliers
set kp to 0.5.
set kd to 0.1.
set kpr to 0.001.
set kdr to 0.001.
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
set pitchtweak to 0.
set prevapoapsis to 0.
set prevaltitude to 0.

//throttle variables
set maxthrottle to 1.
set errormax to 10.
set errormin to -10.

//base throttle
set bd to body("kerbin").
lock heregrav to constant():G*bd:mass/((altitude+bd:radius)^2).
lock gravforce to mass*heregrav.
lock TWR to (ship:maxthrust / gravforce).
lock baset to (1/TWR).

//heading locks
lock topRot to ship:facing*R(-90,0,0).
lock topUnit to topRot:Vector.
lock starRot to ship:facing*R(0,90,0).
lock starUnit to starRot:Vector.
lock fwdRot to ship:facing*R(0,0,-90).
lock fwdUnit to fwdRot:Vector.
lock pitchOff to 90*VDOT(desiredHeading:vector,topUnit).
lock yawOff to 90*VDOT(desiredHeading:vector,starUnit).
lock rotOff to 90*VDOT(desiredHeading:vector,fwdUnit).

set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"starUnit",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"topUnit",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"fwdUnit",4,true).

//control variables

//speed
lock targetspeed to ship:termvelocity.
lock speed to velocity:surface:mag.
//where do you want to go today?
set desiredHeading to heading(90,90).
set step to 1.
stage.
lock long to ship:geoposition:lng.
set tA to 80000.
set tOV to sqrt((constant():G*bd:mass)/(bd:radius + tA)).

set starttime to time:seconds.
when time:seconds > starttime+10 then {set maxthrottle to 0.8.}.
when altitude > 10000 then {lock desiredHeading to ship:prograde+r(0,pitchtweak,0).}.
when altitude > 25001 then {
	toggle RCS.
}.
when altitude > 40001 then {
	set targetspeed to 2400. lock speed to velocity:orbit:mag.
	set kpr to 0.001.
	set kdr to 0.1.
	set kpy to 0.001.
	set kdy to 0.1.
	set kpp to 0.001.
	set kdp to 0.1.
}.

when ship:apoapsis >= tA then { 
	set targetspeed to 0. 
	lock flv to heading(90,0):vector.
	lock pgv to ship:prograde:vector.
	lock desiredHeading to heading(90,0-VANG(flv,pgv)).
}.

when stage:liquidfuel <= 1 then {
	wait 1.
	stage.
}.

when altitude > tA - 10000 then {
	set baset to 0. set targetspeed to tOV.
}.

until step <> 1 {
	set vd0:vec to desiredHeading:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	
	clearscreen.
	print step.
	print long.
	
	print "GRAVITY".
	print "grav: "+gravforce.
	print "mass: "+mass.
	print "TWR: "+TWR.
	print "SPEED".
	print "Target: "+ targetspeed.
	print "Actual: "+ speed.
	set let to et.
	set et to (targetspeed - speed).
	set pthrottle to round((kp * et),2).
	set throttleerrorderivative to (et - let) / 1.
	set dthrottle to round((kd * throttleerrorderivative),2).
	set othrottle to pthrottle + dthrottle.
	print "PID output = "+othrottle+" (P="+pthrottle+" I=0 D="+dthrottle+")".
	if TWR = 0 {
		set desiredthrottle to 0.5.
	}
	else {
		set desiredthrottle to baset + (othrottle / errormax).
	}.
	lock throttle to min(maxthrottle,desiredthrottle).

	print "ROLL".
	set rTarget to desiredHeading:Roll - 180.
	print "Target: "+ rTarget.
	print "Actual: "+ facing:Roll.
	set lastRollError to rE.
	set rE to max(facing:Roll,rTarget) - min(facing:Roll,rTarget).
	if rE > 180 {set rE to (360 - rE)* -1.}.
	print "Error: "+rE.
	set proll to round((kpr * rE),2).
	set rollerrorderivative to (rE - lastRollError) / 1.
	set derroll to round((kdr * rollerrorderivative),2).
	set oroll to (proll + derroll).	
	print "PID output = "+oroll+" (P="+proll+" I=0 D="+derroll+")".
	set ship:control:roll to oroll.
	
	print "PITCH".
	print "Target: "+ desiredHeading:Pitch.
	print "Actual: "+ facing:Pitch.
	set lastPitchError to pE.
	set pE to pitchOff.
	if pE > 180 {set pE to (360 - pE) * -1.}.
	print "Error: "+pE.
	set ppitch to round((kpp * pE),2).
	set pitcherrorderivative to (pE - lastPitchError) / 1.
	set derpitch to round((kdp * pitcherrorderivative),2).
	set opitch to (ppitch + derpitch).	
	print "PID output = "+opitch+" (P="+ppitch+" I=0 D="+derpitch+")".
	set ship:control:pitch to opitch.
	
	print "YAW".
	print "Target: "+ desiredHeading:Yaw.
	print "Actual: "+ facing:Yaw.

	set lastYawError to yE.
	set yE to yawOff.
	if yE > 180 {set yE to (360 - yE) * -1.}.
	print "Error: "+yE.
	set pyaw to round((kpy * yE),2).
	set yawerrorderivative to (yE - lastYawError) / 1.
	set deryaw to round((kdy * yawerrorderivative),2).
	set oyaw to (pyaw + deryaw).	
	print "PID output = "+oyaw+" (P="+pyaw+" I=0 D="+deryaw+")".
	set ship:control:Yaw to oyaw.
	
	wait 0.1.
}.

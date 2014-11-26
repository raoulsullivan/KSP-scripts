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
set ethrottle to 0.
set eroll to 0.
set epitch to 0.
set eyaw to 0.

//initial errors
set rollError to 0.
set pitchError to 0.
set yawError to 0.

//throttle variables
set maxthrottle to 0.75.
set errormax to 10.
set errormin to -10.

//base throttle
set bd to body("kerbin").
lock heregrav to constant():G*bd:mass/((altitude+bd:radius)^2).
lock gravforce to mass*heregrav.
lock TWR to (ship:maxthrust / gravforce).
lock basethrottle to (1/TWR).

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

set desiredalt to 80000.
set turnalt to 10000.
when altitude > turnalt then {set step to "Gravity turn!". lock desiredHeading to ship:PROGRADE.}.
when altitude > 30000 then {set targetspeed to 2400.}.
when ship:obt:APOAPSIS > desiredalt then {set step to "Coast". set targetspeed to 0.}.
when altitude > desiredalt * 0.9 then {set step to "Circularise". lock desiredHeading to ship:PROGRADE+R(0,-10,0). set targetspeed to 2400.}.

//stage.
set step to "Launch!".

until step = 2 {
	set vd0:vec to desiredHeading:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	clearscreen.
	print step.
	print "GRAVITY".
	print "grav: "+gravforce.
	print "mass: "+mass.
	print "TWR: "+TWR.
	print "SPEED".
	print "Target: "+ targetspeed.
	print "Actual: "+ speed.
	set lethrottle to ethrottle.
	set ethrottle to (targetspeed - speed).
	set pthrottle to round((kp * ethrottle),2).
	
	set throttleerrorderivative to (ethrottle - lethrottle) / 1.
	set dthrottle to round((kd * throttleerrorderivative),2).
	
	set othrottle to pthrottle + dthrottle.
	print "PID output = "+othrottle+" (P="+pthrottle+" I=0 D="+dthrottle+")".
	if TWR = 0 {
		set desiredthrottle to 0.5.
	}
	else {
		set desiredthrottle to basethrottle + (othrottle / errormax).
	}.
	
	lock throttle to min(maxthrottle,desiredthrottle).

	print "ROLL".
	set rTarget to desiredHeading:Roll - 180.
	print "Target: "+ rTarget.
	print "Actual: "+ facing:Roll.

	set lastRollError to rollError.
	set rollError to max(facing:Roll,rTarget) - min(facing:Roll,rTarget).
	//set rollError to rotOff.
	if rollError > 180 {set rollError to (360 - rollError)* -1.}.
	print "Error: "+rollError.
	
	set proll to round((kpr * rollError),2).
	set rollerrorderivative to (rollError - lastRollError) / 1.
	set derroll to round((kdr * rollerrorderivative),2).
	set oroll to (proll + derroll).	
	print "PID output = "+oroll+" (P="+proll+" I=0 D="+derroll+")".
	set ship:control:roll to oroll.
	
	print "PITCH".
	print "Target: "+ desiredHeading:Pitch.
	print "Actual: "+ facing:Pitch.

	set lastPitchError to pitchError.
	set pitchError to pitchOff.
	if pitchError > 180 {set pitchError to (360 - pitchError) * -1.}.
	print "Error: "+pitchError.
	
	set ppitch to round((kpp * pitchError),2).
	set pitcherrorderivative to (pitchError - lastPitchError) / 1.
	set derpitch to round((kdp * pitcherrorderivative),2).
	set opitch to (ppitch + derpitch).	
	print "PID output = "+opitch+" (P="+ppitch+" I=0 D="+derpitch+")".
	set ship:control:pitch to opitch.
	
	print "YAW".
	print "Target: "+ desiredHeading:Yaw.
	print "Actual: "+ facing:Yaw.

	set lastYawError to yawError.
	set yawError to yawOff.
	if yawError > 180 {set yawError to (360 - yawError) * -1.}.
	print "Error: "+yawError.
	
	set pyaw to round((kpy * yawError),2).
	set yawerrorderivative to (yawError - lastYawError) / 1.
	set deryaw to round((kdy * yawerrorderivative),2).
	set oyaw to (pyaw + deryaw).	
	print "PID output = "+oyaw+" (P="+pyaw+" I=0 D="+deryaw+")".
	set ship:control:Yaw to oyaw.

	wait 0.1.
}.


wait until altitude > 70001.
print "SCIENCE!".
toggle AG1.
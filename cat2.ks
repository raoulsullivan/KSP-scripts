print "1".
wait 1.

//where do you want to go today?
set desiredHeading to ship:facing.

stage.
print "Launch!".

//pid multipliers
set kp to 0.5.
set kd to 0.1.
set kpr to 0.001.
set kdr to 0.01.
set kpy to 1.
set kdy to 0.
set kpp to 1.
set kdp to 0.

//errors for derivatives
set ethrottle to 0.
set eroll to 0.
set epitch to 0.
set eyaw to 0.

set maxthrottle to 0.75.

set errormax to 10.
set errormin to -10.

lock targetspeed to ship:termvelocity.
lock speed to velocity:surface:mag.
set errorsum to 0.

set gConst to constant():G. // The Gravitational constant
set bd to body("kerbin").
set bodyRadius to bd:radius.
set bodyMass to bd:mass.
lock heregrav to gConst*bodyMass/((altitude+bodyRadius)^2).
lock gravforce to mass*heregrav.
print "grav: "+gravforce.
print "mass: "+mass.
lock TWR to (ship:maxthrust / gravforce).
print "TWR: "+TWR.
print "speed: "+speed.
lock basethrottle to (1/TWR).

set step to 1.
when altitude > 12000 then {set desiredHeading to up -R(45,0,0).}.
when altitude > 30000 then {set targetspeed to 2400.}.

set headingError to desiredHeading - facing.
set rollError to 0.
set pitchError to 0.
set yawError to 0.

until step = 2 {
	clearscreen.
	print "SPEED".
	print "Target: "+ targetspeed.
	print "Actual: "+ speed.
	set lethrottle to ethrottle.
	
	set ethrottle to (targetspeed - speed).
	set pthrottle to round((kp * ethrottle),2).
	
	set throttleerrorderivative to (ethrottle - lethrottle) / 1.
	set dthrottle to round((kd * throttleerrorderivative),2).
	
	set othrottle to pthrottle + dthrottle.
	set desiredthrottle to basethrottle + (othrottle / errormax).
	
	lock throttle to min(maxthrottle,desiredthrottle).
	print "PID output = "+othrottle+" (P="+pthrottle+" I=0 D="+dthrottle+")".

	set lastHeadingError to headingError.
	set headingError to desiredHeading - facing.
	print "ROLL".
	print "Target: "+ desiredHeading:Roll.
	print "Actual: "+ facing:Roll.

	set lastRollError to rollError.
	set rollError to max(facing:Roll,desiredHeading:Roll) - min(facing:Roll,desiredHeading:Roll).
	if rollError > 180 {set rollError to (360 - rollError) * -1.}.
	print "Error: "+rollError.
	
	set proll to round((kpr * rollError),2).
	set rollerrorderivative to (rollError - lastRollError) / 1.
	set derroll to round((kdr * rollerrorderivative),2).
	set oroll to (proll + derroll).	
	print "PID output = "+oroll+" (P="+proll+" I=0 D="+derroll+")".
	//set ship:control:roll to oroll.
	
	print "PITCH".
	print "Target: "+ desiredHeading:Pitch.
	print "Actual: "+ facing:Pitch.

	set lastPitchError to pitchError.
	set pitchError to max(facing:Pitch,desiredHeading:Pitch) - min(facing:Pitch,desiredHeading:Pitch).
	if pitchError > 180 {set pitchError to (360 - pitchError) * -1.}.
	print "Error: "+pitchError.
	
	set ppitch to round((kpp * pitchError),2).
	set pitcherrorderivative to (pitchError - lastPitchError) / 1.
	set derpitch to round((kdp * pitcherrorderivative),2).
	set opitch to (ppitch + derpitch) * -1.	
	print "PID output = "+opitch+" (P="+ppitch+" I=0 D="+derpitch+")".
	set ship:control:pitch to opitch.
	
	print "YAW".
	print "Target: "+ desiredHeading:Yaw.
	print "Actual: "+ facing:Yaw.

	set lastYawError to yawError.
	set yawError to max(facing:Yaw,desiredHeading:Yaw) - min(facing:Yaw,desiredHeading:Yaw).
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
print "1".
wait 1.

//desired control variables
set dyaw to ship:up:yaw.
set dpitch to ship:up:pitch.
set droll to 270.

//actual control variables
lock aroll to ship:facing:roll.
lock apitch to ship:facing:pitch.
lock ayaw to ship:facing:yaw.

stage.
print "Launch!".

//pid multipliers
set kp to 0.5.
set kd to 0.1.
set kpr to 0.001.
set kdr to 0.01.
set kpy to 0.03.
set kdy to 0.01.
set kpp to 0.03.
set kdp to 0.01.

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
when altitude > 12000 then {set dpitch to ship:up:pitch +45.}.
when altitude > 30000 then {set targetspeed to 2400.}.



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

	print "ROLL".
	print "Target: "+ droll.
	print "Actual: "+ aroll.
	set leroll to eroll.
	
	set eroll to (droll - aroll).
	print "Error: "+ eroll.
	if eroll < -180 {print "invert". set eroll to ((360+eroll)*-1).}
	else if eroll > 180 {print "normal". set eroll to ((360-eroll)).}.
	set eroll to eroll *-1.
	print "Error: "+ eroll.
	set proll to round((kpr * eroll),2).
	
	set rollerrorderivative to (eroll - leroll) / 1.
	set derroll to round((kdr * rollerrorderivative),2).

	set oroll to (proll + derroll).	
	set ship:control:roll to proll.
	
	print "PID output = "+oroll+" (P="+proll+" I=0 D="+derroll+")".
	
	print "YAW".
	print "Target: "+ dyaw.
	print "Actual: "+ ayaw.
	set leyaw to eyaw.
	
	set eyaw to (dyaw - ayaw).
	print "Error: "+ eyaw.
	if eyaw < -180 {print "invert". set eyaw to ((360+eyaw)).}
	else if eyaw > 180 {print "normal". set eyaw to ((360-eyaw)*-1).}.
	set eyaw to eyaw.
	print "Error: "+ eyaw.
	set pyaw to round((kpy * eyaw),2).
	
	set yawerrorderivative to (eyaw - leyaw) / 1.
	set deryaw to round((kdy * yawerrorderivative),2).

	set oyaw to (pyaw + deryaw).	
	set ship:control:yaw to oyaw.
	
	print "PID output = "+oyaw+" (P="+pyaw+" I=0 D="+deryaw+")".
	
	print "PITCH".
	print "Target: "+ dpitch.
	print "Actual: "+ apitch.
	set lepitch to epitch.
	
	set epitch to (dpitch - apitch).
	print "Error: "+ epitch.
	if epitch < -180 {print "invert". set epitch to ((360+epitch)).}
	else if epitch > 180 {print "normal". set epitch to ((360-epitch)*-1).}.
	set epitch to epitch *-1.
	print "Error: "+ epitch.
	set ppitch to round((kpp * epitch),2).
	
	set pitcherrorderivative to (epitch - lepitch) / 1.
	set derpitch to round((kdp * pitcherrorderivative),2).

	set opitch to (ppitch + derpitch).	
	set ship:control:pitch to opitch.
	
	print "PID output = "+opitch+" (P="+ppitch+" I=0 D="+derpitch+")".

	wait 0.1.
}.


wait until altitude > 70001.
print "SCIENCE!".
toggle AG1.
//pid multipliers
set kpr to 0.001.
set kdr to 0.1.
set kpy to 0.001.
set kdy to 0.1.
set kpp to 0.001.
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

set desiredHeading to heading(90,0).

until step <> 1 {
	set vd0:vec to desiredHeading:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	
	clearscreen.

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
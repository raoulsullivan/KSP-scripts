//pid multipliers
set kp to 0.5.
set kd to 0.1.
set kpr to 0.01.
set kdr to 0.5.
set kpy to 0.01.
set kdy to 0.5.
set kpp to 0.01.
set kdp to 0.5.

//errors for derivatives
set et to 0.
set er to 0.
set ep to 0.
set ey to 0.

//initial errors
set rE to 0.
set pE to 0.
set yE to 0.

lock tH to ship:prograde+r(0,0,180).

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



until 0 {
	set vd0:vec to tH:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.

	set rTarget to tH:Roll - 180.
	set lRE to rE.
	set face to ship:facing.
	set rE to face:Roll - rTarget.
	if rE > 180 {set rE to (360 - rE)* -1.}.
	set ship:control:roll to (kpr * rE)+(kdr*(rE - lRE)).
	print (rTarget + " +/- "+ face:Roll +" = "+rE) at (0,2).
	print ("("+kpr+" * "+rE+") + ("+kdr+" * ("+rE+" - "+lRE+")) = " + ship:control:roll) at (0,3).
	//set ship:control:roll to 0.
	
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
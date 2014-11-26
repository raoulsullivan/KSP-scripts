clearscreen.
copy PIDsetup from 0.
set PIDvars to list().
run PIDsetup.
delete PIDsetup.
copy PID1 from 0.
print "TRIXIE LAND CALLED".
lock tH to ship:retrograde.
lock dF to tH.

//sets up PIDvars, direction Units and Off, vectors, inputs



lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rollOff to tH:roll - ship:facing:roll.

set rE to 0.
set pE to 0.
set yE to 0.

set step to "Not Done.".
RCS on.

//calculate landing altitude.
//maximum acceleration
set finalvelocity to 0.
set thrustpower to 1.
set bd to ship:obt:body.
lock gravacc to (bd:mass * constant():g) / ((ship:altitude + bd:radius) ^ 2).
lock maxacc to ship:maxthrust * 1 / ship:mass.
//lock totalacc to maxacc - gravacc.

lock totalacc to (ship:maxthrust * 1 / ship:mass) - ((bd:mass * constant():g) / ((ship:altitude + bd:radius) ^ 2)).
set ta1 to totalacc.
lock tp to ((ta1 + ((bd:mass * constant():g) / ((ship:altitude + bd:radius) ^ 2))) * ship:mass) / ship:maxthrust.
lock sp to (gravacc * ship:mass) / ship:maxthrust. 


//finalvelocity-ship:velocity=2*totalacc*distance
lock d1 to ship:velocity:surface:mag / totalacc.
lock d2 to ship:velocity:surface:mag / 2.
lock distance to d1 * d2.
//lock thrustpower to (((((finalvelocity-ship:velocity:surface:mag) / ALT:RADAR) / 2) + gravacc) * ship:mass) / ship:maxthrust.
lock relativevelocity to ship:velocity:surface.
set onTarget to false.
set topRate to 0.
set starRate to 0.
when onTarget then {
	lock throttle to 1.
	when ship:obt:ECCENTRICITY >= 0.99 then {
		lock throttle to 0.
		when distance+10 > alt:radar then {
			lock throttle to tp.
			set pThresh to 0.
			set yThresh to 0.
			set rThresh to 0.
			when verticalspeed >= -3 then {
				lock th to up + r(0,0,90).
				lock throttle to sp.
				lock topRate to VDOT(relativevelocity,topUnit)*-1.
				lock starRate to VDOT(relativevelocity,starUnit)*-1.
				
				when verticalspeed >= 0 then {
					lock throttle to 0.
					set landtime to time.
					when time > (landtime + 1) then {rcs off.}.
				}.
			}
		}.
	}.
}.

until step = "Done" {
	set PIDvectors[4]:vec to relativevelocity.
	set ship:control:top to topRate.
	set ship:control:starboard to starRate.
	
	print round(gravacc,2)+"   " at (0,5).
	print round(maxacc,2)+"   " at (0,6).
	print round(totalacc,2)+"   " at (0,7).
	print round(tp,2)+"   " at (0,8).
	print round(sp,2)+"   " at (0,9).
	print round(distance)+"   " at (0,10).
	print round(ALT:RADAR,2)+"    " at (0,11).
	print round(ship:velocity:surface:x,2)+"    " at (0,12).
	print round(ship:velocity:surface:y,2)+"    " at (0,13).
	print round(ship:velocity:surface:z,2)+"    " at (0,14).
	print round(verticalspeed,2)+"    " at (0,15).
	run PID1(1, 1, 1).
	wait 0.1.
}
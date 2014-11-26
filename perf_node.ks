//performs the next node (nodex).
clearscreen.
print "PERF_NODE CALLED".
//whether to control roll when performing maneuver. set to false for normal/antinormal
declare parameter rollcontrol.
//thrust power to use (0-1)
declare parameter thrustpower.
//number of rcs thrusters available
declare parameter rcsthrusters.
//use rcs if dv is less than the threshold.
declare parameter rcsthreshold.

set step to "Warp to align".
set nodex to nextnode.
if nodex:deltav:mag < rcsthreshold {
	set usercs to true.
	print "Use RCS for this burn".
	set thrust to rcsthrusters * 1.
	set isp to 260.
} else {
	set usercs to false.
	print "Use main engines for this burn".
	set thrust to ship:maxthrust.
	set isp to 380.
}.
set thrust to thrust * 1000.
print "Thrust available (kN): "+thrust/1000.
print "ISP: "+isp.

set mfinal to ship:mass*1000/(constant():e^(abs(nodex:deltav:mag)/(isp * 9.8066))).
print("Mass after burn: "+round(mfinal)).
set mchange to (ship:mass*1000 - mfinal).
print("Mass change: "+round(mchange)).
set mdot to thrust*thrustpower/(isp * 9.8066).
print "Mass change per second: "+round(mdot).
set burntime to mchange/mdot.
print "Burn time: "+round(burntime).
set burnstart to nodex:eta+time - (burntime/2).
print("Burn start: "+burnstart).
set burnstop to burnstart + burntime.
set timetoburn to time - burnstart.
print("Time to burn: "+timetoburn).
	
set burnstart to nodex:eta+time - (burntime/2).
set burnstop to burnstart + burntime.
set warp to 3.
when time >= burnstart-90 then {
	set warp to 0.
	set step to "Align".
	when abs(nodex:deltav:mag) < 3 then { 
		if time < burnstop {
			print "Locking node now".
			set tH to nodex:burnvector:direction+r(0,0,-90).
		}.
	}.
	RCS on.
}.
when time >= burnstart then {
	set step to "Thrust".
	if usercs = true {
		set ship:control:fore to thrustpower.
	}
	else {
		lock throttle to thrustpower.
	}.
}.

lock tH to nodex:burnvector:direction+r(0,0,-90).

copy PIDsetup from 0.
set PIDvars to list().
run PIDsetup.
delete PIDsetup.
copy PID1 from 0.

lock df to ship:prograde + r(0,0,0).
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(df:vector,topUnit).
lock yawOff to 90*VDOT(df:vector,starUnit).
lock rollOff to df:roll - ship:facing:roll.

copy PID1 from 0.
until time > burnstop {
	run PID1(.5, .5, 0).
	wait 0.1.
}.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.
set ship:control:fore to 0.
lock throttle to 0.
rcs off.
unlock tH.
remove nodex.
set step to "Done".

delete PID1.

print "PERF_NODE DONE".
wait 5.
clearscreen.
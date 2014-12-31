//performs the next node (n).
clearscreen.
print "PERF_NODE CALLED".
declare parameter rollcontrol, thrustpower, rcsthrusters, rcsthreshold, usewarp, progradelock.

set n to nextnode.
if n:deltav:mag < rcsthreshold {
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

set mfinal to ship:mass*1000/(constant():e^(abs(n:deltav:mag)/(isp * 9.8066))).
print("Mass after burn: "+round(mfinal)).
set mchange to (ship:mass*1000 - mfinal).
print("Mass change: "+round(mchange)).
set mdot to thrust*thrustpower/(isp * 9.8066).
print "Mass change per second: "+round(mdot).
set burntime to mchange/mdot.
print "Burn time: "+round(burntime).
set burnstart to n:eta+time - (burntime*0.5).
print("Burn start: "+burnstart).
set burnstop to burnstart + burntime.
set timetoburn to time - burnstart.
print("Time to burn: "+timetoburn).
	
set burnstart to n:eta+time - (burntime/2).
set burnstop to burnstart + burntime.
if usewarp {
set warp to 3.
}.
when time >= burnstart-90 then {
	set warp to 0.
	when abs(n:deltav:mag) < 3 then { 
		print "Locking node now".
		set df to n:burnvector:direction+r(0,0,270).
	}.
	RCS on.
}.
when time >= burnstart then {
	if usercs = true {
		set ship:control:fore to thrustpower.
	}
	else {
		lock throttle to thrustpower.
	}.
}.

lock df to n:burnvector:direction+r(0,0,270).
if progradelock {lock df to prograde + r(0,0,270).}.

copy PID1 from 0.
set rp to 0.
set rcspower to ship:mass/100.
if rollcontrol {set rp to rcspower.}.
until time > burnstop {
	print "Burn start in "+round(time:seconds-burnstart:seconds)+"    " at (0,dRow-3).
	print "Burn stop in "+round(time:seconds-burnstop:seconds)+"    " at (0,dRow-2).
	run PID1(rcspower, rcspower, rp).
	wait 0.1.
}.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.
set ship:control:fore to 0.
lock throttle to 0.
rcs off.
unlock df.
remove n.
delete PID1.

print "PERF_NODE DONE".
wait 5.
clearscreen.
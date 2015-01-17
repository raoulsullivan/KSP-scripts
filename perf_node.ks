//performs the next node (n).
clearscreen.
print "PERF_NODE CALLED".
declare parameter rollcontrol, thrustpower, rcsthrusters, rcsthreshold, usewarp, progradelock, nodelock.

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
	set timetowarp to burnstart:Seconds - 90 - time:seconds.
	print "TTW:"+timetowarp.
	wait 5.
	copy warpscript from 0.
	run warpscript(timetowarp).
	delete warpscript.
}.
when time >= burnstart-90 then {
	//when abs(n:deltav:mag) < 5 then { 
	//	print "Locking node now".
	//	set dF to n:burnvector:direction+r(0,0,270).
	//}.
	RCS on.
}.
lock tp to min(n:deltav:mag/(maxthrust/mass), 1) * thrustpower.
when time >= burnstart then {
	if usercs = true {
		set ship:control:fore to tp.
	}
	else {
		lock throttle to tp.
	}.
}.

lock dF to n:burnvector:direction+r(0,0,270).
if nodelock {
	set dF to n:burnvector:direction+r(0,0,270).
}.
if progradelock {lock dF to prograde + r(0,0,270).}.
copy pidsetup from 0.
run pidsetup(0.1,2,0.1,2,0.1,2,.1,.1,.1).
delete pidsetup.
copy PID1 from 0.
set rp to 0.
set rcspower to ship:mass/200.
if rollcontrol {set rp to rcspower.}.
set dv0 to n:deltav.
until n:deltav:mag <= 0.1 {
	if vdot(dv0, n:deltav) < 0 {
        print "Ballsed - T+" + round(missiontime) + " End burn, remain dv " + round(n:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, n:deltav),1) at (0,0).
        lock throttle to 0.
        break.
    }
	print "Burn start in "+round(time:seconds-burnstart:seconds)+"    " at (0,dRow-4).
	print "Burn stop in approx. "+round(time:seconds-burnstop:seconds)+"    " at (0,dRow-3).
	print "Node delta-v remaining: "+round(n:deltav:mag,2)+"    " at (0,dRow-2).
	run PID1(rcspower, rcspower, rp).
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
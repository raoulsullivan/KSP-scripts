clearscreen.
copy PIDsetup from 0.
set PIDvars to list().
run PIDsetup.
delete PIDsetup.
copy PID1 from 0.

lock df to up + r(0,0,0).

lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(df:vector,topUnit).
lock yawOff to 90*VDOT(df:vector,starUnit).
lock rollOff to df:roll - ship:facing:roll.


print "TRIXIE RETURN CALLED".
toggle ag3.
wait 5.

stage.
wait 1.
stage.
rcs on.
lock throttle to 1.
when alt:radar > 2000 then {
	lock df to heading(90,0)+ R(0,0,0).
	toggle ag2.
	when ship:apoapsis > 50000 then {
		lock throttle to 0.
		set step to "Done".
	}.
}.

set step to "Not done".

until step = "Done" {
	run PID1(.6, .6, .6).
	wait 0.1.
}
rcs off.
copy calc_circnode from 0.
run calc_circnode(50000).
add nodex.
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0).
copy calc_hohmannnode from 0.
run calc_hohmannnode("Kerbin").
delete calc_hohmannnode.
//run perf_node(false,1,0,0).
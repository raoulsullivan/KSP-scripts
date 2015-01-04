copy calc_interceptnode from 0.
run calc_interceptnode("Minmus").
set warp to 3.
set ttime to time + nextnode:eta - 350.
wait until time > ttime.
set warp to 0.
remove nextnode.
run calc_interceptnode("Minmus").
delete calc_interceptnode.
wait 5.
clearscreen.
copy perf_node from 0.
run perf_node(true,1,0,0,true,false).
delete perf_node.
if ship:obt:hasnextpatch = false {
	set derped to true.
} else {
	if ship:obt:nextpatch:body:name <> "Minmus" {
		set derped to true.
	} else {
		set derped to false.
	}.
}.

if derped {
	if apoapsis > body("Minmus"):obt:apoapsis {
		lock df to retrograde.
		when apoapsis < body("Minmus"):obt:apoapsis then {set step to "Done".}.
	} else {
		lock df to prograde.
		when apoapsis > body("Minmus"):obt:apoapsis then {set step to "Done".}.
	}.
	copy pidsetup from 0.
	run pidsetup(0.1,2,0.1,2,0.1,2,1,1,1).
	delete pidsetup.
	when ontarget = true then { lock throttle to 0.01.}.
	rcs on.
	until step = "Done" {
		run pid1(.2,.2,1).
	}.
	rcs off.
	lock throttle to 0.
}.
copy trim_intercept from 0.
run trim_intercept(20000).
delete trim_intercept.
set warp to 5.
wait until ship:obt:body:name = "Minmus".
set warp to 0.
copy calc_circnode from 0.
run calc_circnode(ship:periapsis).
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false).
delete perf_node.
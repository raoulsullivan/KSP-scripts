clearscreen.
print "TRIXIE RETURN CALLED".
toggle ag3.
wait 5.
for x in ship:partstagged("returnMonoprop") {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", true).
}.
for x in ship:partstagged("returnBattery") {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
}.

copy PIDsetup from 0.
run PIDsetup(.1,1,.1,1,.1,1,1,1,1).
delete PIDsetup.
copy PID1 from 0.

lock df to up + r(0,0,0).

stage.
rcs on.
lock throttle to 1.
when alt:radar > 2000 then {
	lock df to heading(90,0)+ R(0,0,0).
	toggle ag2.
	when ship:apoapsis > 30000 then {
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
run calc_circnode(30000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0, true, false).
delete perf_node.
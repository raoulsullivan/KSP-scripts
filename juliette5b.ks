//performs the node and re-enters kerbin
lock df to nd:deltav:mag.
clearscreen.
set sr to ship:partsdubbed("Landerdockingport")[0].
sr:getmodule("moduledockingnode"):doevent("undock").

copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.

set df to PROGRADE.
copy PIDsetup from 0.
run PIDsetup(.2,1,.2,1,.2,1,3,3,3).
delete PIDsetup.

copy PID1 from 0.
set done to false.
lock kperi to ship:obt:nextpatch:periapsis.
rcs on.
if  kperi > 31000 {
	when ontarget then {
		lock throttle to 0.01.
		when kperi < 31000 then { set done to true.}.
	}.
} else {
	when ontarget then {
		set ship:control:fore to -1.
		when kperi > 31000 then { set done to true.}.
	}.
}.
lock rcspower to ship:mass/100.
until done {
	run pid1(rcspower,rcspower,rcspower).
	wait 0.1.
}.
lock throttle to 0.
set ship:control:fore to 0.
rcs off.

//warp to outside SOI
copy warpscript from 0.
run warpscript(ETA:TRANSITION + 180).
delete warpscript.
//trim re-entry
//set nd to node(time:seconds + 180, 0, 0, 0).
//add nd.
//lock nextpe to nd:orbit:periapsis.
//if nextpe > 31000 {
//	until nextpe < 31000 {
//		set nd:radialout to nd:radialout - 0.1.
//	}.
//} else {
//	until nextpe > 31000 {
//		set nd:radialout to nd:radialout + 0.1.
//	}.
//}.
//copy perf_node from 0.
//run perf_node(false,1,0,0,true,false,false).
//delete perf_node.

set warp to 4.
wait until altitude < 300000.
set warp to 0.
rcs on.
print "TURN ON ELECTRICITY!".
lock df to retrograde.
until altitude < 150000 {
	run pid1(1,1,1).
	wait 0.1.
}.
stage.
stage.
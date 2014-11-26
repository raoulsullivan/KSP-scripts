//launcher script for the Trixie missions
declare parameter tA1, tA2, tInc. //grav turn (8000), final (80000), inclination (90)
set df to heading(tInc,90)+ R(0,0,0).

copy pidsetup from 0.
run pidsetup(0.5,0.5,0.5,0.5,0.5,0.5,1,1,1).
delete pidsetup.

print "LAUNCH SEQUENCE START".
set countdown to 3.
until countdown = 0 {
	print countdown+"...   " at (0,1).
	set countdown to countdown - 1.
	wait 1.
}.
print "ASCENDING TO "+round(tA1/1000)+"km".
lock throttle to 1.
stage.
when altitude > tA1 then {
	print "GRAVITY TURN START".
	lock df to heading(tInc,90-(sqrt(altitude/tA2)*90)).
}.
when apoapsis > 30000 then {
	lock df to prograde+r(0,0,0).
}.
when altitude > 15001 then {
	print "REACTION CONTROL ON".
	RCS on.
}.
when stage:solidfuel = 0 then { stage.}.
when stage:liquidfuel = 0 then { stage.}.
copy pid1 from 0.
until apoapsis >= tA2 {
	run pid1(1,1,1).
	wait 0.1.
}.
delete pid1.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.

//coast and circularisation
print "COAST TO APOAPSIS AT "+tA2/1000+"km".
lock throttle to 0.
rcs off.
copy calc_circnode from 0.
run calc_circnode(80000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,false).
delete perf_node.
print "LAUNCH COMPLETE".
print "APOAPSIS: "+round(apoapsis/1000,3)+"km".
print "PERIAPSIS: "+round(periapsis/1000,3)+"km".
print "INCLINATION: "+obt:inclination+"deg".
stage.
copy calc_incnode from 0.
run calc_incnode(0).
delete calc_incnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true).
delete perf_node.
copy calc_circnode from 0.
run calc_circnode(80000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,true).
delete perf_node.
copy calc_circnode from 0.
run calc_circnode(80000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,true).
delete perf_node.
lock df to north.
set rollcontrol to false.
copy perf_alignment from 0.
run perf_alignment.
delete perf_alignment.
print "Done. Go launch Trixie 1 now!".
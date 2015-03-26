//launcher script for the Juliette mission
declare parameter tA1, tA2, tInc.
set df to heading(tInc,90)+ R(0,0,0).

copy pidsetup from 0.
run pidsetup(0.1,0.1,0.5,0.5,0.5,0.5,1,1,1).
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
wait 10.
lock throttle to 0.8.
when altitude > tA1 then {
	print "GRAVITY TURN START".
	lock df to heading(tInc,90-(sqrt(altitude/tA2)*90)).
}.
when apoapsis > 30000 then {
	lock df to prograde+r(0,0,0).
}.
when ship:maxthrust <= 0 then {
	stage.
	lock throttle to 1.
}.
copy pid1 from 0.
until apoapsis >= tA2 {
	run pid1(1,1,1).
	wait 0.1.
}.
lock throttle to 0.

delete pid1.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.

//coast and circularisation
print "COAST TO APOAPSIS AT "+tA2/1000+"km".
lock throttle to 0.
rcs off.
copy pidsetup from 0.
run pidsetup(0.1,1,0.1,1,0.1,1,1,1,1).
delete pidsetup.
copy calc_circnode from 0.
run calc_circnode(80000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,false,false,false).
delete perf_node.
lock throttle to 0.
stage.
print "LAUNCH COMPLETE".
print "APOAPSIS: "+round(apoapsis/1000,3)+"km".
print "PERIAPSIS: "+round(periapsis/1000,3)+"km".
print "INCLINATION: "+obt:inclination+"deg".
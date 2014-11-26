//calculates a node to adjust inclination to *whatever*
//sets nodex and burntime variables

clearscreen.
print "CALC-INCNODE CALLED".
declare parameter desiredinc.
print "Desired inclination: "+desiredinc.
set v to ship:velocity:orbit:mag.
set deltainc to desiredinc-ship:obt:inclination.
print "Inclination change: "+round(deltainc,2).
set dv to 2*v * sin(deltainc / 2).
print "Velocity change: "+round(dv).

set degfroman to 360- mod(ship:obt:argumentofperiapsis + ship:obt:trueanomaly,360).
print "Degrees to ascending node: "+round(degfroman).
if degfroman > 180 {
	print "Descending node is closer".
	set dv to -1*dv.
	set degfroman to degfroman - 180.
}.
set timetoan to ship:obt:period * (degfroman)/360.
print "Time to node (mins): "+round(timetoan/60,1).
set nodex to node (time:seconds+timetoan,0,dv,0).
add nodex.
print "CALC-INCNODE DONE".
wait 5.
clearscreen.
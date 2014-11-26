//calculates a node to adjust inclination to *whatever*
//sets nodex and burntime variables
//requires thrust in kN

declare parameter desiredinc.
desclare parameter isp.
declare parameter thrust.
set v to ship:velocity:orbit:mag.
set deltainc to desiredinc-ship:obt:inclination.
set dv to 2*v * sin(deltainc / 2).

set degfroman to mod(ship:obt:argumentofperiapsis + ship:obt:trueanomaly,360).
print degfroman.
set timetoan to ship:obt:period * (360-degfroman)/360.
print timetoan.
set nodex to node (time:seconds+timetoan,0,dv,0).
add nodex.

set mfinal to ship:mass/(constant():e^(abs(dv)/(isp * 9.8066))).
set mchange to (ship:mass - mfinal) * 1000.
set mdot to thrust/(isp * 9.8066).
set burntime to mchange/mdot.
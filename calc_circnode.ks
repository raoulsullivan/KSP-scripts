//calculates a node to adjust altitude
//sets nodex and burntime variables

clearscreen.
print "CALC-CIRCNODE CALLED".
declare parameter desiredalt.
print "Desired altitude: "+desiredalt.

if eta:periapsis < eta:apoapsis or eta:apoapsis = 0 {
	print "Periapsis coming up next - will adjust apoapsis".
	set nxt to ship:periapsis. 
	set nexteta to eta:periapsis.
} else {
	print "Apoapsis coming up next - will adjust periapsis".
	set nxt to ship:apoapsis. 
	set nexteta to eta:apoapsis.
}.
set bd to ship:obt:body.
set r to nxt + bd:radius.
set k to constant():g * bd:mass.
print "Radius at node: "+r.
set v to sqrt(k*((2/r) - (1/ship:obt:semimajoraxis))).
print "Velocity at node: "+round(v).

set desiredsma to (r + desiredalt + bd:radius) / 2.
print "Desired SMA: "+desiredsma.
set desiredv to sqrt(k*((2/r) - (1/desiredsma))).
print "Desired velocity: "+round(desiredv).
set dv to desiredv - v.
print "Delta v: "+round(dv).

print "Time to node (mins): "+round(nexteta/60,1).
set nodex to node (time:seconds+nexteta,0,0,dv).

print "CALC_CIRCNODE DONE".
wait 5.
clearscreen.
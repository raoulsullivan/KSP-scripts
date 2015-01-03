//calculate transfer time and required DV
declare parameter tgt.
set bd to body("Kerbin").
set target to body(tgt).
set u to (constant():g*bd:mass).
set currentradius to ship:obt:apoapsis + bd:radius.
set targetradius to target:obt:apoapsis + bd:radius.
set targetsma to (targetradius + bd:radius + currentradius) / 2.
set xfertime to ((2*constant():pi)*sqrt((targetsma^3)/(constant():g*bd:mass)))/2.
print (xfertime/60).
set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/(ship:obt:semimajoraxis + ((target:obt:apoapsis - ship:periapsis)/2))))).
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
set desireddv to desiredvelocityatap -currentvelocityatap.
print(desireddv).

//calculate current phase angle
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print ("Phase angle: "+phaseangle).


lock xferoffset to mod(((xfertime/target:obt:period)*360),360).
set departurediff to phaseangle - (180-xferoffset).
if (departurediff < 0) {set departurediff to 360+departurediff.}.
print ("Departure diff: "+departurediff).
set timetoxfer to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer).
set waitingoffset to mod(((timetoxfer/target:obt:period)*360),360).
set departurediff to departurediff + waitingoffset.
print ("Departure diff: "+departurediff).
set timetoxfer2 to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer2).
if timetoxfer2 < 300 {
	set timetoxfer2 to timetoxfer2 + ship:obt:period.
}.
set x to node (time:seconds+timetoxfer2,0,0,desireddv).
add x.
wait(5).
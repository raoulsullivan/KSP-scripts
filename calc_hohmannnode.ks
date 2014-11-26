//sets phaseangle variable
declare parameter targetName.
clearscreen.
print "CALC_HOHMANNNODE TO "+targetName.

copy calc_hohmannxfer from 0.
run calc_hohmannxfer(targetName).
delete calc_hohmannxfer.
copy calc_phaseangle from 0.
run calc_phaseangle(targetName).
delete calc_phaseangle.

set target to targetName.
lock xferoffset to mod(((transfertime/target:obt:period)*360),360).
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
set nodex to node (time:seconds+timetoxfer2,0,0,deltav).
add nodex.

print "CALC_HOHMANNNODE DONE".
wait 5.
clearscreen.
//sets transfertime and deltav variables
declare parameter targetName.
clearscreen.
print "CALC_HOHMANNXFER TO "+targetName.
set bd to ship:obt:body.
set target to targetName.
set u to (constant():g*bd:mass).
set currentradius to ship:obt:apoapsis + bd:radius.
set targetradius to target:obt:apoapsis + bd:radius.
set targetsma to (targetradius + bd:radius + currentradius) / 2.
set transfertime to ((2*constant():pi)*sqrt((targetsma^3)/(constant():g*bd:mass)))/2.
print "Transfer time (mins): "+round(transfertime/60).
set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/(ship:obt:semimajoraxis + ((target:obt:apoapsis - ship:periapsis)/2))))).
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
set deltav to desiredvelocityatap -currentvelocityatap.
print "Transfer dv: "+round(deltav).

print "CALC_HOHMANNXFER DONE".
wait 5.
clearscreen.
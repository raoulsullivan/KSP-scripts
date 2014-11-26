//sets phaseangle variable
declare parameter targetName.
clearscreen.
print "CALC_PHASEANGLE TO "+targetName.

set target to targetName.
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print "Phase angle: "+round(phaseangle).

print "CALC_PHASEANGLE DONE".
wait 5.
clearscreen.
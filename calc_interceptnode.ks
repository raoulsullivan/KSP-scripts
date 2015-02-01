//calculate transfer time and required DV
declare parameter tgt, dvbudget.
set bd to body("Kerbin").
set target to body(tgt).
set u to (constant():g*bd:mass).
set currentradius to ship:obt:apoapsis + bd:radius.
set targetradius to target:obt:apoapsis + bd:radius.

if dvbudget > 0 {
	print "Delta-v budget: "+dvbudget.
	print "Target radius: "+round(targetradius/1000)+"km".
	//when will this orbit cross the target?
	set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
	set predictedvelocityatap to currentvelocityatap + dvbudget.

	set predictedsma to 1 / ( (2 / currentradius) -  (predictedvelocityatap^2 / u) ).
	print "Predicted semi-major axis: "+round(predictedsma/1000)+"km".

	set predictedrp to currentradius.
	set predictedra to predictedsma*2 - predictedrp.
	set predictede to 1 - (2 / ((predictedra/predictedrp) + 1)).
	print "Predicted eccecntricity: "+round(predictede,2).

	set predictedp to predictedsma*(1-predictede^2).
	set trueanomalyatintercept to arccos((predictedp/targetradius - 1)/predictede).
	print "Predicted true anomaly at intercept "+round(trueanomalyatintercept).

	set eccentricanomalyatintercept to (arccos((predictede + cos(trueanomalyatintercept)) / (1 + predictede * cos(trueanomalyatintercept)))).
	print "Predicted eccentric anomaly at intercept "+round(eccentricanomalyatintercept).

	set e2 to eccentricanomalyatintercept / (180/constant():pi).

	set meananomalyatintercept to e2 - (predictede * sin(eccentricanomalyatintercept)).
	print "Predicted mean anomaly at intercept "+round(meananomalyatintercept,2).

	set predictedorbitalperiod to 2*constant():pi * sqrt(predictedsma^3 / u ).
	print "Predicted orbital period: "+round(predictedorbitalperiod)+" / "+round(predictedorbitalperiod/3600,2).

	set xfertime to meananomalyatintercept*(predictedorbitalperiod/(2*constant():pi)).
	print "Predicted time to intercept: "+round(xfertime)+" / "+round(xfertime/3600,2).
	set desireddv to dvbudget.
} else {
	set trueanomalyatintercept to 180.
	set targetsma to (targetradius + bd:radius + currentradius) / 2.
	set xfertime to ((2*constant():pi)*sqrt((targetsma^3)/(constant():g*bd:mass)))/2.
	print (xfertime/60).
	set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/(ship:obt:semimajoraxis + ((target:obt:apoapsis - ship:periapsis)/2))))).
	set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
	set desireddv to desiredvelocityatap -currentvelocityatap.
	print(desireddv).
}.

//calculate current phase angle
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print ("Phase angle: "+phaseangle).

set anglediff to 180-trueanomalyatintercept.
print anglediff.
lock xferoffset to mod(((xfertime/target:obt:period)*360),360).
set departurediff to phaseangle - (180-xferoffset) +anglediff.
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
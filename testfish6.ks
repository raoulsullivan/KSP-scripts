set initialmass to ship:mass*1000.
set finalmass to initialmass - ((stage:LiquidFuel + stage:Oxidizer)*5).
set isp to 380.
set dv to (isp * 9.8066)*ln(initialmass/finalmass).
print dv.
set bd to body("Kerbin").
lock currentradius to ship:obt:apoapsis + bd:radius.
set dv to 900.

set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentradius)-(1/ship:obt:semimajoraxis))).
print currentvelocityatap.
set newvelocityatap to currentvelocityatap+dv.
print newvelocityatap.
set u to (constant():g*bd:mass).

set newsma to 1/((2/currentradius)- ((newvelocityatap^2)/u)).

set newsma2 to (u/(((newvelocityatap^2 / 2) - (u / currentradius))*2))*-1.

print ("New SMA: "+newsma).
print ("New SMA2: "+newsma2).
set newradius to (newsma*2) - currentradius.
print ("New radius: "+newradius).
set newalt to newradius - bd:radius.
print ("New altitude: "+newalt).
set newe to 1 - (2/((newradius/currentradius)+1)).
print ("New eccentricity: "+newe).

set ecc to ship:obt:ECCENTRICITY.
print ecc.
set theta to ship:obt:TRUEANOMALY.
print theta.
print ("cosine method").
set tophalf to ecc+(cos(theta)).
set bottomhalf to 1+(ecc*cos(theta)).
set e to arccos(tophalf/bottomhalf).
if theta > 180 {
	set e to 360-e.
}.
print e.
set mean to e - (ecc*sin(e)).
print mean.
set r to 12000000.

set cose to ((r/newsma)-1)/(newe*-1).
set desirede to arccos(cose).
print ("Desired eccentric anomaly for intercept: "+desirede).

set newtrue2 to arccos( (cos(desirede) - newe) / (1 - (newe*cos(desirede))) ).
print ("Desired true anomaly: "+newtrue2).

set desirederad to (constant():pi/360)*desirede.
set newmean to (desirederad - (newe*sin(desirederad))).
set newmean2 to (desirede - (newe*sin(desirede))).
print ("Desired new mean anomaly: "+newmean).
print ("Desired new mean anomaly2: "+newmean2).
set newcompletion to newmean/(2*constant():pi).
//set newcompletion to newmean2/360.
print ("New completion: "+newcompletion).

set neworbitalperiod to (2*constant():pi)*sqrt((newsma^3)/u).
print ("New orbital period: "+(neworbitalperiod/3600)).
set newtime to neworbitalperiod*newcompletion.
print ("New Xfer time: "+(newtime/3600)).

set target to body("mun").
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
print ("Ship orbital position: "+shippos).

lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
print ("Target orbital position: "+targetpos).

lock xferoffset to mod(((newtime/target:obt:period)*360),360).

lock targetpos2 to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly - xferoffset),360).
print ("Target orbital position2: "+targetpos2).

lock timetoxfer to ship:obt:period*(xferoffset2/360).

set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print ("Phase angle: "+phaseangle).

lock departureangle to newtrue2 - xferoffset.
print ("Departure angle: "+departureangle).

set departurediff to phaseangle - departureangle.
if (departurediff < 0) {set departurediff to 360+departurediff.}.
print ("Departure diff: "+departurediff).

lock timetoxfer to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer).

set x to node (time:seconds+timetoxfer,0,0,dv).
add x.

lock resultorbit to x:orbit:patches.
print resultorbit#1:body.
lock resultalt to resultorbit#1:periapsis.
until (resultalt < 0) {set x:eta to x:eta -1.}.
print ("done").
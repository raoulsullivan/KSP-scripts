//intercepts the other spaceship
clearscreen.
print "TRIXIE INTERCEPT CALLED".
set bd to ship:obt:body.
set k to constant():g * bd:mass.

//get adjustment required
//calculate phase angle
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
print "Ship position: "+shippos.
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
print "Target position: "+targetpos.
if shippos > targetpos {
	set phaseangle to shippos - targetpos.
} else {
	set phaseangle to shippos + 360 - targetpos.
}
//set phaseangle to phaseangle * -1.
print "Phase angle: "+phaseangle.

//need to know how long the tgt will take to complete this phase angle - i.e. how long for true anomaly to change
set e to target:obt:eccentricity.
print e.
set rad to 57.2957795.

set tgttruea to target:obt:TRUEANOMALY.
print "target true anomaly: "+tgttruea.
set tgtmeana to target:obt:MEANANOMALYATEPOCH.
print "target mean anomaly: "+tgtmeana.
set tgtecca to arccos((e+cos(tgttruea))/(1 + e * cos(tgttruea))).
print "target eccentric anomaly: "+tgtecca.

set tgtmeana to tgtecca - ((180/constant():pi)*e*sin(tgtecca)).
set tgtmeana to tgtmeana / (180/constant():pi).
print "target mean anomaly: "+tgtmeana.
print "----".
set tgttruea2 to tgttruea + phaseangle.
print "Target true anomaly 2: "+round(tgttruea2,2).
set tgtecca2 to arccos((e+cos(tgttruea2))/(1 + e * cos(tgttruea2))).
print "Target eccentric anomaly 2: "+round(tgtecca2,2).
set tgtmeana2 to tgtecca2 - ((180/constant():pi)*e*sin(tgtecca2)).
set tgtmeana2 to tgtmeana2 / (180/constant():pi).
print "Target mean anomaly 2: "+round(tgtmeana2,2).

//mean motion change
set mc1 to tgtmeana2 - tgtmeana.
set mc2 to 2*constant():pi - tgtmeana + tgtmeana2.
set meanchange to mod(max(mc1,mc2),2*constant():pi).
print "Change in target mean motion: "+round(meanchange,2).
set perchange to meanchange / (2*constant():pi).
print "Change in target mean motion: "+round(perchange,2).

//calculate time delta required
set timedelta to target:obt:period*perchange.
print "Time delta: "+round(timedelta).

//calculate the orbit required for this
set desiredperiod to target:obt:period + timedelta.
print "Desired orbital period (mins): "+round(desiredperiod/60).
//set desiredsma to ((desiredperiod^2 * k)/4*constant():pi^2)^(1/3).
set desiredsma to (((desiredperiod/(2*constant():pi))^2)*k)^(1/3).
print "Desired semi-major axis: "+round(desiredsma).

//set node.
set r to ship:altitude + bd:radius.
print "Radius at node: "+r.
//set v to sqrt(k*((2/r) - (1/ship:obt:semimajoraxis))).
set v to ship:velocity:orbit:mag.
print "Velocity at node: "+round(v).
set desiredv to sqrt(k*((2/r) - (1/desiredsma))).
print "Desired velocity: "+round(desiredv).
set dv to desiredv - v.
print "Delta v: "+round(dv).
print "Time to node (mins): "+round(90/60,1).
set nodex to node (time:seconds+90,0,0,dv).
add nodex.
wait 5.
copy perf_node from 0.
run perf_node(true,1,0,0,true,false,false).
delete perf_node.
set warp to 3.
set dtime to ship:obt:period * 0.9.
print dtime.
set dtime to time+dtime.
wait until time > dtime.
set warp to 0.
//ok now for clever.

print "Done?".
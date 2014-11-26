//intercepts the other spaceship
clearscreen.
print "TRIXIE INTERCEPT CALLED".
set bd to ship:obt:body.
set k to constant():g * bd:mass.

//get intercept altitude
set interceptalt to 80000.
//get adjustment required
//calculate phase angle
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
print "Ship position: "+shippos.
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
print "Target position: "+targetpos.
set phaseangle to targetpos-shippos.
//if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print "Phase angle: "+phaseangle.

//calculate time delta required
set timedelta to ship:obt:period*(phaseangle/360).
print "Time delta: "+round(timedelta).

//calculate the orbit required for this
set desiredperiod to ship:obt:period - timedelta.
print "Desired orbital period (mins): "+round(desiredperiod/60).
//set desiredsma to ((desiredperiod^2 * k)/4*constant():pi^2)^(1/3).
set desiredsma to (((desiredperiod/(2*constant():pi))^2)*k)^(1/3).
print "Desired semi-major axis: "+round(desiredsma).

//set node.
set r to ship:altitude + bd:radius.
print "Radius at node: "+r.
set v to sqrt(k*((2/r) - (1/ship:obt:semimajoraxis))).
print "Velocity at node: "+round(v).
set desiredv to sqrt(k*((2/r) - (1/desiredsma))).
print "Desired velocity: "+round(desiredv).
set dv to desiredv - v.
print "Delta v: "+round(dv).
print "Time to node (mins): "+round(300/60,1).
set nodex to node (time:seconds+300,0,0,dv).
add nodex.

run perf_node(false,1,8,5).
set backagain to max(eta:periapsis, eta:apoapsis).
set nodex to node (time:seconds+backagain,0,0,-dv).
add nodex.
run perf_node(false,1,8,5).
print "Done?".
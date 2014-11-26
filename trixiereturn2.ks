clearscreen.

//calculate SOI
set bd to ship:obt:body.
set sma to (bd:apoapsis + 2*bd:body:radius + bd:periapsis)/2.
set soi to sma*(bd:mu/bd:body:mu)^0.4.
//print "Mun soi: "+soi.

set rb to 200000.
set mu to 6.5138398*10^10.
set pi to constant():pi.
//copy soinode from 0.

//move origin to central body (i.e. Kerbin)
set ps to V(0,0,0) - body:position.
print "ps: "+ps.
set pk to body:body:position - body:position.
print "pk: "+pk.
// hohmann orbit properties, s: ship, m: mun, 0: mun orbit, 1: hohmann transfer, 2: earth orbit
// major semi axis
set sma1 to pk:mag.
//print "Semi major axis: "+sma1.
set smah to ( pk:mag + 660000 )/2.
print "Print smah: "+smah.
set vmun to sqrt(body:body:mu / pk:mag).   // Mun's orbital velocity
print "Print velocity of mun: "+vmun.
set vh to sqrt(vmun^2 - body:body:mu * (1/smah - 1/sma1)). // Hohmann velocity
print "Print hohmann velocity: "+vh.
set vhe to vmun - vh.                   // hyperbolic excess velocity
print "Print hyperbolic excess: "+vhe. 


set ra to bd:radius + (periapsis+apoapsis)/2.
set v2 to sqrt(vhe^2 - 2*bd:mu*(1/soi - 1/ra)).
print "Velocity for soi: "+v2.

set vom to velocity:orbit:mag.          // actual velocity
set r to bd:radius + altitude.                 // actual distance to body
set va to sqrt( vom^2 - 2*bd:mu*(1/ra - 1/r) ).
print "Average velocity: "+va.
set deltav to v2 - va.
print "DV: "+deltav.


set pc to body:body:position - body:position.
// angular positions
set ac to arctan2(pc:x,pc:z).
//print "AC: "+ac.
set as0 to arctan2(ps:x,ps:z).
print "As0: "+as0.



//run soinode(-99,vhe).

set soe to v2^2/2 - mu/ra.              // specific orbital energy
set h to ra * v2.
set e to sqrt(1+(2*soe*(h/mu)^2)).      // eccentricity of hyperbolic orbit
set tai to arccos(-1/e).                // angle between the periapsis vector and the departure asymptote
set sma to -mu/(2*soe).
set ip to -sma/tan(arcsin(1/e)).        // impact parameter 
set aip to arctan(ip/soi).              // angle to turn leaving mun soi point on mun orbit
set asoi to tai - aip.
set aburn to ac + -99 + asoi.
//set ops to 2 * pi * sqrt(sma^3/mu).      // ship orbital period
until aburn < as0 { set aburn to aburn - 360. }
set eta to (as0 - aburn)/360 * ship:obt:period.
set nd to node(time:seconds + eta, 0, 0, deltav).
add nd.

copy perf_node from 0.
run perf_node(false,1,0,0).
delete perf_node.
lock kperi to ship:obt:nextpatch:periapsis.
rcs on.
if  kperi > 60000 {
	set ship:control:fore to 1.
	until kperi <= 60000 { wait 0.1.}.
	set ship:control:fore to 0.
} else {
	set ship:control:fore to -1.
	until kperi >= 60000 { wait 0.1.}.
	set ship:control:fore to 0.	
}.
set warp to 1.
until ship:altitude > 70000 {
	wait 1.
}.
set warp to 0.
rcs off.
toggle ag1.
wait 3.
stage.
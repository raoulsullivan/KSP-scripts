clearscreen.

//calculate SOI
set bd to ship:obt:body.
set sma to (bd:apoapsis + 2*bd:body:radius + bd:periapsis)/2.
set soi to sma*(bd:mu/bd:body:mu)^0.4.

set rb to 200000.
set pi to constant():pi.

//move origin to central body (i.e. Kerbin)
set ps to V(0,0,0) - body:position.
print "ps: "+ps.
set pk to body:body:position - body:position.
print "pk: "+pk.
// hohmann orbit properties, s: ship, m: mun, 0: mun orbit, 1: hohmann transfer, 2: earth orbit
set sma1 to pk:mag.
print "Semi major axis: "+sma1.
set smah to ( pk:mag + 660000 )/2.
print "Print smah: "+smah.
set vmun to sqrt(body:body:mu / pk:mag).   // Mun's orbital velocity
print "Print velocity of mun: "+vmun.
set vh to sqrt(vmun^2 - body:body:mu * (1/smah - 1/sma1)). // Hohmann velocity
print "Print hohmann velocity: "+vh.
set vmun to vmun+500.
set vhe to vmun - vh.                   // hyperbolic excess velocity
print "Print hyperbolic excess: "+vhe. 


set ra to bd:radius + (periapsis+apoapsis)/2.
set v2 to sqrt(vhe^2 - 2*body:mu*(1/soi - 1/ra)).
print "Velocity for soi: "+v2.
//set v2 to 300.

set vom to velocity:orbit:mag.          // actual velocity
set r to bd:radius + altitude.                 // actual distance to body
set va to sqrt( vom^2 - 2*body:mu*(1/ra - 1/r) ).
print "Average velocity: "+va.
set deltav to v2 - va.
print "DV: "+deltav.
set deltav to 500.

set pc to body:body:position - body:position.
// angular positions
set ac to arctan2(pc:x,pc:z).
set as0 to arctan2(ps:x,ps:z).
print "As0: "+as0.




set soe to v2^2/2 - body:mu/ra.              // specific orbital energy
print "specific orbital energy: "+soe.
set h to ra * v2.
print "h: "+h.
set e to sqrt(1+(2*soe*(h/body:mu)^2)).      // eccentricity of hyperbolic orbit
print "eccentricity of hyperbolic orbit: "+e.
set tai to arccos(-1/e).                // angle between the periapsis vector and the departure asymptote
set sma to - (body:mu/(2*soe)).
set ip to -sma/tan(arcsin(1/e)).        // impact parameter 
set aip to arctan(ip/soi).              // angle to turn leaving mun soi point on mun orbit
set asoi to tai - aip.
set aburn to ac + -9 + asoi.
until aburn < as0 { set aburn to aburn - 360. }
set eta to (as0 - aburn)/360 * ship:obt:period.
set nd to node(time:seconds + eta, 0, 0, deltav).
add nd.

lock nextpe to nd:orbit:nextpatch:periapsis.
until nextpe < 31000 {
	set nd:eta to nd:eta + 0.01.
}

wait 10.
copy warpscript from 0.
run warpscript(nd:eta - 180).
delete warpscript.
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
set vhe to vmun - vh.                   // hyperbolic excess velocity
print "Print hyperbolic excess: "+vhe. 


set ra to bd:radius + (periapsis+apoapsis)/2.
set v2 to sqrt(vhe^2 - 2*body:mu*(1/soi - 1/ra)).
print "Velocity for soi: "+v2.

set vom to velocity:orbit:mag.          // actual velocity
set r to bd:radius + altitude.                 // actual distance to body
set va to sqrt( vom^2 - 2*body:mu*(1/ra - 1/r) ).
set isp to 390.
set initialmass to ship:mass*1000.
set fuelmass to (ship:partsdubbed("Rockomax X200-32 Fuel Tank")[0]:mass - ship:partsdubbed("Rockomax X200-32 Fuel Tank")[0]:drymass)*1000.
set finalmass to initialmass - fuelmass.
print "Initial mass: "+round(initialmass).
print "Final mass: "+round(finalmass).

set deltav to (9.81 * isp) * ln(initialmass / finalmass).
print "Average velocity: "+va.
set v2 to va + deltav.
print "DV: "+round(deltav).
print "V2: "+round(v2).

set pc to body:body:position - body:position.
// angular positions
set ac to arctan2(pc:x,pc:z).
set as0 to arctan2(ps:x,ps:z).
print "As0: "+as0.




set soe to v2^2/2 - body:mu/ra.              // specific orbital energy
print soe.
set h to ra * v2.
print h.
set e to sqrt(1+(2*soe*(h/body:mu)^2)).      // eccentricity of hyperbolic orbit
print e.
set tai to arccos(-1/e).                // angle between the periapsis vector and the departure asymptote
set sma to - (body:mu/(2*soe)).
set ip to -sma/tan(arcsin(1/e)).        // impact parameter
print "Impact parameter "+round(ip). 
set aip to arctan(ip/soi).              // angle to turn leaving mun soi point on mun orbit
set asoi to tai - aip.
set aburn to ac + 0 + asoi.
until aburn < as0 { set aburn to aburn - 360. }
set eta to (as0 - aburn)/360 * ship:obt:period.
set nd to node(time:seconds + eta, 0, 0, deltav).
add nd.

copy trim_intercept_node from 0.
run trim_intercept_node("Kerbin",31000, true).
delete trim_intercept_node.

lock df to nd:deltav:mag.
wait 5.
clearscreen.

copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.

set df to PROGRADE.
copy PIDsetup from 0.
run PIDsetup(.2,1,.2,1,.2,1,3,3,3).
delete PIDsetup.

copy PID1 from 0.
set step to "Not done".
lock kperi to ship:obt:nextpatch:periapsis.
rcs on.
if  kperi > 33000 {
	when ontarget then {
		lock throttle to 0.01.
		when kperi <= 33000 then { set step to "Done".}.
	}.
} else {
	when ontarget then {
		set ship:control:fore to -1.
		when kperi >= 33000 then { set step to "Done".}.
	}.
}.
lock rcspower to ship:mass/100.
until step = "Done" {
	run pid1(rcspower,rcspower,rcspower).
	wait 0.1.
}.
lock throttle to 0.
set ship:control:fore to 0.
rcs off.
set warp to 4.
until ship:altitude > 65000 {
	wait 1.
}.
set warp to 0.
set sr to ship:partsdubbed("Mk1-2 command pod")[0].
sr:getmodule("btsmmodulecrewreport"):doevent("crew report").
copy warpscript from 0.
run warpscript(ETA:TRANSITION + 300).
delete warpscript.
sr:getmodule("btsmmodulecrewreport"):doevent("crew report").

//re-entry
copy warpscript from 0.
run warpscript(ETA:periapsis - 180).
delete warpscript.
lock df to retrograde.
//remember to turn on power before separating!
when altitude < 100000 then {
	stage.
}.
rcs on.
until altitude < 40000 {
	run pid1(1,1,1).
	wait 0.1.
}.
until altitude < 5000 {
	wait 1.
}.
stage.
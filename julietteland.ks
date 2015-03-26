//joleen landing
//burn so the pe is 0


lock df to ship:retrograde.
rcs on.
copy pidsetup from 0.
run pidsetup(0.1,2,0.1,2,0.1,2,1,1,5).
delete pidsetup.
copy pid3setup from 0.
run pid3setup(0.1,3,0.1,3,0.1,3).
delete pid3setup.

copy pid3 from 0.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set ontarget to false.
set thrustpower to 1.

set alignposition to ship:position + ((ship:up*r(180,0,0)):vector*(alt:radar - 50)).
lock relativevelocity to ship:velocity:surface.

set fuelrate to 2.61.
set fuelmass to 5.
set initialmass to ship:mass.
lock totalacc to (ship:maxthrust * 0.8 / ship:mass) - ((body:mass * constant():g) / ((ship:altitude + body:radius) ^ 2)).
lock timetostop to ship:velocity:surface:mag / totalacc.
lock fueluse to fuelrate * timetostop * fuelmass.
lock finalmass to initialmass - fueluse.
lock totalacc2 to (ship:maxthrust * 0.8 / ship:mass) - ((body:mass * constant():g) / ((ship:altitude + body:radius) ^ 2)).
lock timetostop2 to ship:velocity:surface:mag / totalacc.
lock stoppingdistance to (timetostop * ship:velocity:surface:mag) / 2.

lock disterror to stoppingdistance - alt:radar + 10.
lock tpower to 0.8 + (disterror/250).

//for x in ship:partstagged("landerMonoprop") {
//	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", false).
//}.

//for x in ship:partstagged("landerTopRCS") {
//	x:getmodule("modulercs"):doevent("enable rcs port").
//}.

//ship:partstagged("landerBattery")[0]:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).

when ontarget then {
	lock throttle to thrustpower.
}.
when ship:obt:ECCENTRICITY >= 0.99 then {
	lock throttle to 0.
	lock df to ship:SRFRETROGRADE.
	when stoppingdistance + 50 > alt:radar then {
		lock throttle to tpower.
		when verticalspeed > -3 then {
			legs on.
			lock throttle to 0.
			set enginepower to 0.3.
			set usepid3 to true.
			lock df to up+r(0,0,90).
			print "Attempting touchdown...".
			set translationpower to 0.5.
		}.
	}.
}.

when status = "LANDED" then {
	set waittime to time + 2.
	when time > waittime then {
		set step to "Done".
	}.
}.
	

set translationpower to 0.
set enginepower to 0.
set usepid3 to false.

set step to "Not done".
until step = "Done" {
	run pid1(rcspower,rcspower,rcspower).
	if usepid3 {
		run pid3(translationpower,translationpower,enginepower,true).
	}.
	wait 0.01.
	print "Stopping time: "+round(timetostop)+"          " at (0, drow+12).
	print "Stopping distance: "+round(stoppingdistance)+"          " at (0, drow+13).
	print "Radar altitude: "+round(alt:radar)+"          " at (0, drow+14).
	print "Distance error: "+round(disterror)+"          " at (0, drow+15).
}.

lock throttle to 0.
RCS off.
print "We appear to be landed".
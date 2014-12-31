clearscreen.
set landerMonopropgroup to ship:partstagged("landerMonoprop").
for x in landerMonopropgroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", true).
}.
set RCSgroup to ship:partstagged("landerRCSBottom").
for x in RCSgroup {
	x:getmodule("modulercs"):doevent("enable rcs port").
}.
set transferBatterygroup to ship:partstagged("landerBattery").
for x in transferBatterygroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
}.
for x in ship:partstagged("landerPort") {
	x:getmodule("moduledockingnode"):doevent("undock").
}.
stage.
set alignposition to ship:position + ((ship:up*r(180,0,0)):vector*(alt:radar - 50)).
lock relativevelocity to ship:velocity:surface.
lock df to retrograde.

copy pidsetup from 0.
run PIDsetup(0.1,1.5,0.1,1.5,0.1,1.5,2,2,2).
delete pidsetup.
copy pid3setup from 0.
run pid3setup(0.1,1,0.1,1,0.1,1).
delete pid3setup.


copy pid1 from 0.
copy pid3 from 0.

RCS on.

set aligns to false.
set ontarget to false.

set bd to body("mun").
lock totalacc to (ship:maxthrust * 1 / ship:mass) - ((bd:mass * constant():g) / ((ship:altitude + bd:radius) ^ 2)).
lock timetostop to ship:velocity:surface:mag / totalacc.

lock stoppingdistance to (timetostop * ship:velocity:surface:mag) / 2.

set hoverheight to 0.

when onTarget then {
	lock throttle to 1.
	when ship:obt:ECCENTRICITY >= 0.99 then {
		lock throttle to 0.
		lock df to ship:SRFRETROGRADE.
		when stoppingdistance+hoverheight > alt:radar then {
			lock throttle to 1.
			when verticalspeed > -3 then {
				legs on.
				lock throttle to 0.
				set enginepower to 0.3.
				set usepid3 to true.
				lock df to up.
				print "Attempting touchdown...".
				set translationpower to 0.5.
				when status = "LANDED" then {
					set waittime to time + 5.
					when time > waittime then {
						set step to "Done".
					}.
				}
			}.
		}.
	}.
}.
set rcspower to 1.
set translationpower to 0.
set enginepower to 0.
set usepid3 to false.

set step to "Not done".
until step = "Done" {
	run pid1(rcspower,rcspower,rcspower).
	if usepid3 {
		run pid3(translationpower,translationpower,enginepower,true).
	}.
	wait 0.1.
	print "Stopping time: "+round(timetostop)+"          " at (0, drow+12).
	print "Stopping distance: "+round(stoppingdistance)+"          " at (0, drow+13).
	print "Radar altitude: "+round(alt:radar)+"          " at (0, drow+14).
}.

lock throttle to 0.
RCS off.
print "We appear to be landed".
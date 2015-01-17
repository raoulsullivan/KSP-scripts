//joleen landing
//burn so the pe is 0
toggle ag1.
toggle ag2.

set goo1 to ship:partsdubbed("goo1")[0].
set goo2 to ship:partsdubbed("goo2")[0].
set goo3 to ship:partsdubbed("goo3")[0].
set modulename to "BTSMModuleScienceExperiment".
set eventname to "expose mystery goo".
goo1:getmodule(modulename):doevent(eventname).

wait 10.

set warp to 5.
until ship:geoposition:lng < 0 {
	wait 1.
}
until ship:geoposition:lng > -20 {
	wait 1.
}
set warp to 0.
lock df to ship:retrograde.
rcs on.
copy pidsetup from 0.
run pidsetup(0.1,1,0.1,1,0.1,1,1,1,5).
delete pidsetup.
copy pid3setup from 0.
run pid3setup(0.1,1,0.1,1,0.1,1).
delete pid3setup.

copy pid3 from 0.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set ontarget to false.
set thrustpower to 1.

set alignposition to ship:position + ((ship:up*r(180,0,0)):vector*(alt:radar - 50)).
lock relativevelocity to ship:velocity:surface.

lock totalacc to (ship:maxthrust * 1 / ship:mass) - ((body:mass * constant():g) / ((ship:altitude + body:radius) ^ 2)).
lock timetostop to ship:velocity:surface:mag / totalacc.
lock stoppingdistance to (timetostop * ship:velocity:surface:mag) / 2.

for x in ship:partstagged("landerMonoprop") {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", false).
}.

for x in ship:partstagged("landerBottomRCS") {
	x:getmodule("modulercs"):doevent("enable rcs port").
}.

ship:partstagged("landerBattery")[0]:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
ship:partstagged("landerBattery")[1]:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
ship:partstagged("landerBattery")[2]:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).

when ontarget then {
	lock throttle to thrustpower.
}.
when ship:obt:ECCENTRICITY >= 0.99 then {
	lock throttle to 0.
	lock df to ship:SRFRETROGRADE.
	when stoppingdistance + 50 > alt:radar then {
		lock throttle to 1.
		when verticalspeed > -3 then {
			legs on.
			lock throttle to 0.
			set enginepower to 0.3.
			set usepid3 to true.
			lock df to up.
			print "Attempting touchdown...".
			set translationpower to 0.5.
		}.
	}.
}.

when altitude < 5000 then {
	stage.
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
	wait 0.1.
	print "Stopping time: "+round(timetostop)+"          " at (0, drow+12).
	print "Stopping distance: "+round(stoppingdistance)+"          " at (0, drow+13).
	print "Radar altitude: "+round(alt:radar)+"          " at (0, drow+14).
}.

lock throttle to 0.
RCS off.
print "We appear to be landed".
toggle ag1.
toggle ag2.
toggle ag3.
goo2:getmodule(modulename):doevent(eventname).
//stage
//burn for vertical descent

//docks?!
clearscreen.

lock dockingportvector to target:facing:vector.
lock relativevelocity to ship:velocity:orbit - target:velocity:orbit.
lock dF to dockingportvector:direction.
lock totalerror to abs(rE) + abs(pE) + abs(yE).
lock te2 to max(0,totalerror - 10).
lock translationpower to max(0,0.2-te2).
lock alignposition to (dockingportvector*15) + target:position.
when alignposition:mag < 0.5 then {
	print "Final approach". 
	lock alignposition to target:position.
	when alignposition:mag < 0.5 then {
		set step to "Done".
	}.
}.

set step to "Not done".
print "Activating lander power and rcs".
set RCSgroup to ship:partstagged("landerRCSBottom").
for x in RCSgroup {
	x:getmodule("modulercs"):doevent("enable rcs port").
}.
set Batterygroup to ship:partstagged("landerBattery").
for x in Batterygroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
}.
set Monopropgroup to ship:partstagged("landerMonoprop").
for x in Monopropgroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", true).
}.
print "Jettison orbital service module".
stage.
print "Moving to final approach position".


copy pidsetup from 0.
run PIDsetup(0.1,1.5,0.1,1.5,0.1,1.5,1,1,1).
delete pidsetup.
copy pid2setup from 0.
run pid2setup(0.1,1,0.1,1,0.1,1).
delete pid2setup.
copy pid1 from 0.
copy pid2 from 0.
rcs on.
lock rcspower to ship:mass/100.
set step to "Not done".
until step = "Done" {
	run pid1(rcspower,rcspower,0).
	run pid2(translationpower,translationpower,translationpower,false).
	wait 0.1.
}.





print "Deactivating lander power and rcs".
for x in RCSgroup {
		x:getmodule("modulercs"):doevent("disable rcs port").
}.
for x in Batterygroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", false).
}.
for x in Monopropgroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", false).
}.
rcs off.
delete pid1.
delete pid2.
print "All done".
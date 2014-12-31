declare parameter targetperiapsis.
if ship:obt:HASNEXTPATCH = False {
	print "Epic fail - no next patch".
} else {
	set p to ship:obt:nextpatch.
}.
copy pidsetup from 0.
run PIDsetup(0.1,1.5,0.1,1.5,0.1,1.5,1,1,1).
delete pidsetup.
lock df to prograde.
copy pid1 from 0.
lock totalerror to abs(rE) + abs(pE) + abs(yE).
lock te2 to max(0,totalerror - 10).
lock translationpower to max(0,0.2-te2).

if p:periapsis > targetperiapsis {
	lock throttle to 0.01.
	when p:periapsis <= targetperiapsis then {set step to "Done".}.
}.
else {
	set ship:control:fore to -translationpower.
	when p:periapsis >= targetperiapsis then {set step to "Done".}.
}.

rcs on.
lock df to prograde.
lock rcspower to ship:mass/100.
set step to "Not done".
until step = "Done" {
	run pid1(rcspower,rcspower,0).
	wait 0.1.
}.
delete pid1.
set ship:control:fore to 0.
lock throttle to 0.
rcs off.

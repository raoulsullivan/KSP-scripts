//docks?!
clearscreen.

lock dockingportvector to target:facing:vector.
lock relativevelocity to ship:velocity:orbit - target:velocity:orbit.
lock dF to dockingportvector:direction + r(180,0,0).
lock totalerror to abs(rE) + abs(pE) + abs(yE).
lock te2 to max(0,totalerror - 10).
lock translationpower to max(0,0.1-te2).
lock alignposition to (dockingportvector*15) + target:position.
when alignposition:mag < 0.5 then {
	print "Final approach". 
	lock alignposition to target:position.
	when alignposition:mag < 0.5 then {
		set step to "Done".
	}.
}.

set step to "Not done".

copy pidsetup from 0.
run pidsetup(0.2,1,0.2,1,0.2,1,0.1,0.1,0.1).
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
rcs off.
delete pid1.
delete pid2.
print "All done".
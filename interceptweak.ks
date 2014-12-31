clearscreen.
copy PIDsetup from 0.
run PIDsetup(0.1,1.5,0.1,1.5,0.1,1.5,1,1,1).
delete PIDsetup.
copy pid2setup from 0.
run pid2setup(0.1,1,0.1,1,0.1,1).
delete pid2setup.
copy PID1 from 0.
copy PID2 from 0.
rcs on.

lock relativevelocity to ship:velocity:orbit - target:velocity:orbit.
//lock rv1 to relativevelocity - relativevelocity:z.
//lock sv1 to ship:velocity:orbit - ship:velocity:orbit:z.
//lock df to ship:velocity:orbit:direction - (relativevelocity:direction - target:direction).
//lock df to VECTOREXCLUDE(ship:velocity:orbit,relativevelocity):direction + r(180,0,0).

lock vx to VECTORCROSSPRODUCT(relativevelocity,target:direction:VECTOR):direction + r(90,0,0).
lock va to vang(vx:vector,relativevelocity).
lock vx2 to vx + r(0,90-va,0).
print va.
if vang(target:direction:VECTOR,vx2:vector) > 90 {lock vx3 to vx2+r(180,0,0).} else {lock vx3 to vx2.}.
lock df to vx3.
set step to "Not done".
set rcspower to 0.2.
when vang(ship:facing:vector,df:vector) < 3 then {
	print "POWEEERRRR".
	lock throttle to 0.5.
	when vang(target:direction:VECTOR,relativevelocity) < 3 then {
		print "CLOSE ENOUGH!".
		lock throttle to 0.
		lock df to relativevelocity:direction + r(180,0,0).
		set pidly to 1.
		when alignposition:mag < 300 then {
			print "BRAKES!".
			set rpower to 1.
			when relativevelocity:z > -3 then {
				print "Over to RCS".
				lock rpower to translationpower.
				set ue to false.
				lock df to alignposition:direction + r(180,0,0).
				when alignposition:mag < 50 then {
					set step to "Done".
				}.
			}.
		}.
	}.
}.

lock dockingportvector to target:facing:vector.
lock alignposition to (dockingportvector*15) + target:position.
lock totalerror to abs(rE) + abs(pE) + abs(yE).
lock te2 to max(0,totalerror - 10).
lock translationpower to max(0,0.2-te2).
set pidly to 0.
set rpower to 0.
set ue to true.
until step = "Done" {
	set PIDvectors[0]:vec to df:vector.
	set PIDvectors[4]:vec to relativevelocity.
	run pid1(rcspower,rcspower,0).
	if pidly = 1 {
		run pid2(translationpower,translationpower,rpower,ue).
	}.
}.
lock throttle to 0.
delete pid1.
delete pid2.
print "Now run trixiedock".

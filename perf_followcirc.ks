declare parameter desiredinc, normalburn.
lock normal to vcrs(body:position,ship:velocity:orbit).
print "normal burn: "+normalburn.
if normalburn {
	lock df to normal:direction.
} else {
	lock df to normal:direction+r(180,0,0).
}.
rcs on.
copy pidsetup from 0.
run pidsetup(0.1,2,0.1,2,0.1,2,1,1,1).
delete pidsetup.
copy PID1 from 0.
set rcspower to ship:mass/100.
set ontarget to false.
set thrustpower to 0.1.
when ontarget then {
	lock throttle to thrustpower.
	when abs(desiredinc-ship:obt:inclination) < 0.1  then {
		set done to true.
	}. 
	when desiredinc < abs(ship:geoposition:lat) then {
		//if ship is outside desired inclination we'll never get to it, so stop burn when close to lat.
		when ship:obt:inclination - abs(ship:geoposition:lat) < 0.1 then {
			set done to true.
		}.
	}.
}.
set done to false.
until done {
	run PID1(rcspower, rcspower, 0).
}.
rcs off.
lock throttle to 0.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.
unlock df.
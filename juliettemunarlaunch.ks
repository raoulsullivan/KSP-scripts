//launch when target is behind a bit
lock diff1 to target:geoposition:lng - ship:geoposition:lng.
lock diff2 to (360 - ship:geoposition:lng) + target:geoposition:lng.
lock remaining to 360 - mod(max(diff1,diff2),360).
set go to false.
set warp to 5.
when remaining > 50 then {
	when remaining < 135 then {
		set warp to 0.
	}
	when remaining < 50 then {
		set go to true.
	}
}
until go {
	print "remaining: "+round(remaining)+"     " at (1,1).
}
set interceptradius to (target:obt:apoapsis + target:obt:periapsis + target:obt:body:radius * 2) / 2.
lock df to heading(90,90).
rcs on.
lock throttle to 0.5.
when alt:radar > 1000 then {
	lock throttle to 1.
	set ontarget to false.
	lock df to heading(90,45).
	legs off.
}
when apoapsis > (interceptradius - target:obt:body:radius) then {
	lock throttle to 0.
	set done to true.
}.

copy pidsetup from 0.
run pidsetup(0.2,1,0.2,1,0.2,1,0.1,0.1,0.1).
delete pidsetup.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set done to false.

until done {
	run pid1(rcspower,rcspower,rcspower).
}
delete PID1.
lock throttle to 0.

//does a followinc burn, but at the relative AN/DN
clearscreen.
lock normal to vcrs(body:position,ship:velocity:orbit).

//calculates relative inclination!
lock pos1 to ship:position - body:position.
lock angmm1 to vcrs(pos1,ship:velocity:orbit).
lock pos2 to target:position - body:position.
lock angmm2 to vcrs(pos2,target:velocity:orbit).
lock angmm3 to angmm1:mag * angmm2:normalized.
lock inc to 180 - arccos(angmm1:y/angmm1:mag).



//calculates descending node
lock i1 to ship:obt:inclination.
lock lan1 to ship:obt:lan.
lock vector1 to V(sin(i1)*cos(lan1),sin(i1)*sin(lan1),cos(i1)).
lock i2 to target:obt:inclination.
lock lan2 to target:obt:lan.
lock vector2 to V(sin(i2)*cos(lan2),sin(i2)*sin(lan2),cos(i2)).
lock vector3 to vcrs(vector1,vector2).
set thing to 90.
if vector3:x > 0 { set thing to 270.}.
lock RLDN to arctan(vector3:y/vector3:x) + thing.

//calculates orbital completion from reference point
lock long_alpha to mod((ship:obt:argumentofperiapsis + ship:obt:lan),360).
lock long_beta to mod((ship:obt:argumentofperiapsis + ship:obt:trueanomaly + ship:obt:lan),360).
lock diff_long_1 to long_alpha - long_beta.
lock diff_long_2 to (360 - long_beta) + long_alpha.
lock completion_long to 360 - mod(max(diff_long_1,diff_long_2),360).
lock diff_RLDN_1 to RLDN - long_beta.
lock diff_RLDN_2 to (360 - long_beta) + RLDN.
lock completion_RLDN to 360 - mod(max(diff_RLDN_1,diff_RLDN_2),360).

if completion_RLDN > 180 {
	set next to "descending".
	set normalburn to true.
} else {
	set next to "ascending".
	set normalburn to false.
}.



if normalburn {
	lock df to normal:direction.
} else {
	lock df to normal:direction+r(180,0,0).
}.

//perform manoeuvre
rcs on.
copy pidsetup from 0.
run pidsetup(0.2,1,0.2,1,0.2,1,0.1,0.1,0.1).
delete pidsetup.
copy PID1 from 0.
set rcspower to ship:mass/100.
set thrustpower to 0.5.
set isp to 390.
set initialmass to ship:mass*1000.
set tonode to 180.
set warp to 5.
when tonode < 10 then {
	set warp to 0.
}


set lastinc to abs(inc).

when tonode < 1 then { 
	//assume circular orbit and calculate dv
	set dv to (2*ship:velocity:orbit:mag) * sin(inc/2).
	print dv.
	set finalmass to initialmass / (constant():e ^ (dv / (9.81 * isp))).
	set masschange to initialmass - finalmass.
	print masschange.
	set mdot to (50*1000)/(isp*9.81).
	print mdot.
	set burntime to masschange / (mdot * thrustpower).
	print burntime.
	lock throttle to thrustpower.
	set endtime to time + burntime.
	when time > endtime then {
		lock throttle to 0.
		set done to true.
	}
}
set done to false.
until done {
	set tonode to round(abs(180-mod(180+completion_RLDN,180))).
	run PID1(rcspower, rcspower, 0).
	print "Remaining to next node: "+tonode+"   "at(0,drow+5).
	print "Next node is: "+next+"   "at(0,drow+6).
	print "Relative inclination is: "+round(inc,3)+"   "at(0,drow+7).
	wait 0.1.
}.
print "Done".
delete pid1.
rcs off.
lock throttle to 0.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.
unlock df.
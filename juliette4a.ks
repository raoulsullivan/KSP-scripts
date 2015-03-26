//calculate when to launch
//assume a perfectly circular ascent(?)
clearscreen.
set interceptradius to (target:obt:apoapsis + target:obt:periapsis + target:obt:body:radius * 2) / 2.
lock df to heading(90,90).
rcs on.
lock throttle to 0.5.
when alt:radar > 1000 then {
	//set done to true.
	lock throttle to 1.
	set ontarget to false.
	//lock df to target:direction+r(180,0,0).
	//lock df to target:prograde.
	lock df to heading(90,45).
	legs off.
}
set perf_inc to false.
when apoapsis > (interceptradius - target:obt:body:radius) then {
	lock throttle to 0.
	//when abs(180-mod(180+completion_RLDN,180)) < 1 then {
		//if next = "descending" {
		//	set ship:control:starboard to 0.3.
		//} else {
		//	set ship:control:starboard to -0.3.
		//}
		//when relativeinc < 0.1 then {
		//	set ship:control:starboard to 0.
		//}
		//print "THRUST!" at (10,1).
	//}
	set perf_inc to true.
}.

copy pidsetup from 0.
run pidsetup(0.2,1,0.2,1,0.2,1,0.1,0.1,0.1).
delete pidsetup.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set done to false.

// calculate angular momentums
//lock vtgt to -1 * target:body:velocity:orbit.
//lock pm to target:body:position-target:body:body:position.
//lock amm to vcrs(pm, vtgt).  
//lock ps to ship:position-body:position.
//lock ams0 to vcrs(ps, ship:velocity:orbit).
//lock ams1 to ams0:mag*amm:normalized.
// inclination between angular momentums
//lock inc to vang(ams0,ams1).

//calculates relative inclination!
lock pos1 to ship:position - body:position.
lock angmm1 to vcrs(pos1,ship:velocity:orbit).
lock pos2 to target:position - body:position.
lock angmm2 to vcrs(pos2,target:velocity:orbit).
lock angmm3 to angmm1:mag * angmm2:normalized.
lock relativeinc to vang(angmm2,angmm3).

//calculates inclination!
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

//turn this into mean anomaly
lock e to ship:obt:eccentricity.
lock theta to ship:obt:trueanomaly.
lock theta2 to mod(ship:obt:trueanomaly+360-completion_RLDN,360).
//lock eccentricanomaly to arccos( (e + cos(theta)) / (1 + e * cos(theta))).
//lock eccentricanomaly2 to arccos( (e + cos(theta2)) / (1 + e * cos(theta2))).
set maxmean to 2*constant():pi.
//lock m0 to (eccentricanomaly - e * sin(eccentricanomaly))*(constant():pi/180).
//lock m1 to (eccentricanomaly2 - e * sin(eccentricanomaly2))*(constant():pi/180).
//lock d1 to m1 - m0.
//lock d2 to (maxmean - m0) + m1.
//lock m3 to mod(max(d1,d2),maxmean).
//lock time to ship:obt:period * (m3/maxmean).


//until done {
//	run pid1(rcspower,rcspower,rcspower).
//}
//set done to false.
until done {
	run pid1(rcspower,rcspower,rcspower).
	set t2 to time.
	if completion_RLDN > 180 {
		set next to "descending".
	} else {
		set next to "ascending".
		//set t2 to time - (ship:obt:period/2).
	}.
	if perf_inc {
		print "relative inclination is "+round(inc,2)+" degrees    " at (0,5).
		if abs(180-mod(180+completion_RLDN,180)) < 1 {
			if next = "descending" {
				set ship:control:starboard to -0.2.
			} else {
				set ship:control:starboard to 0.2.
			}
			if abs(inc) < 0.1 {
				set ship:control:starboard to 0.
				set perf_inc to false.
			}
		}
	}
	//print "next node is "+next+" in "+round(time)+" seconds    " at (0,4).
	print "next node is "+next+" in "+round(completion_RLDN)+" degrees    " at (0,4).
	
	print "completion "+round(completion_RLDN,2)+" degrees    " at (0,6).
}
delete PID1.
lock throttle to 0.

//circularise
copy calc_circnode from 0.
run calc_circnode(20000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,true,false,false).
delete perf_node.
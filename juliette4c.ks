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
lock eccentricanomaly to arccos( (e + cos(theta)) / (1 + e * cos(theta))).
lock eccentricanomaly2 to arccos( (e + cos(theta2)) / (1 + e * cos(theta2))).
set maxmean to 2*constant():pi.
lock m0 to (eccentricanomaly - e * sin(eccentricanomaly))*(constant():pi/180).
lock m1 to (eccentricanomaly2 - e * sin(eccentricanomaly2))*(constant():pi/180).
lock d1 to m1 - m0.
lock d2 to (maxmean - m0) + m1.
lock m3 to mod(max(d1,d2),maxmean).
lock time to ship:obt:period * (m3/maxmean).

set done to false.

clearscreen.
until done {
	print "Relative LDN: "+round(RLDN)+"     " at (0,1).
	print "Current orbit long: "+round(long_beta)+"     " at (0,2).
	print "Current orbit completion: "+round(completion_long/360,2)+"     " at (0,3).
	print "Long diff: "+round(completion_RLDN)+"     " at (0,4).
	print "RLDN orbit completion: "+round(completion_RLDN/360,2)+"     " at (0,5).
	if completion_RLDN > 180 {
		set next to "descending".
	} else {
		set next to "ascending".
	}.
	print "next node is "+next+"     " at (0,6).
	print "true anomaly "+round(theta)+"     " at (0,7).
	print "true anomaly 2 "+round(theta2)+"     " at (0,8).
	print "eccentric anomaly "+round(eccentricanomaly)+"     " at (0,9).
	print "eccentric anomaly 2 "+round(eccentricanomaly2)+"     " at (0,10).
	//print "completionrldn "+round(diff_RLDN_1)+"     " at (0,11).
	//print "completionrldn2 "+round(diff_RLDN_2)+"     " at (0,12).
	print "mean motion 0: "+round(m0,2)+"     " at(0,13).
	print "mean motion 1: "+round(m1,2)+"     " at(0,14).
	print "d1: "+round(d1,2)+"     " at(0,15).
	print "d2: "+round(d2,2)+"     " at(0,16).
	print "mean motion to RLDN: "+round(m3,2)+"     " at(0,17).
	print "time to DN: "+round(time/60,2)+"   " at (0,18).
}


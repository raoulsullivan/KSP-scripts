declare parameter targetperiapsis, desiredinc.
set desiredinc1 to desiredinc.
clearscreen.
print "Trimming insertion periapsis to "+(targetperiapsis/1000)+"km at "+desiredinc+" degrees inclination".
set currentlat to ship:geoposition:lat.
set v to ship:velocity:orbit:mag.
wait 0.1.
set northwards to false.
if ship:geoposition:lat > currentlat {
	set northwards to true.
}.
if desiredinc > abs(currentlat) {
	print "Adjusting inclination directly".
	set twoburns to false.
	set normalburn to true.
	if northwards {
		if desiredinc < ship:obt:inclination {
			set normalburn to false.
		}.
	} else {
		if desiredinc > ship:obt:inclination {
			set normalburn to false.
		}.
	}.
} else {
	print "Adjusting inclination with 2 burns".
	set twoburns to true.
	set normalburn to true.
	set desiredinc to 45.
	if northwards {
		if currentlat > 0 {
			set normalburn to false.
		}.
	} else {
		if currentlat < 0 {
			set normalburn to false.
		}.
	}.
}.
copy perf_followcirc from 0.
run perf_followcirc(desiredinc,normalburn).
if twoburns {
	set theta to obt:trueanomaly.
	set theta0 to 360-obt:argumentofperiapsis.
	set k to body:mass*constant():g.
	set a to obt:semimajoraxis.
	set e to obt:eccentricity.
	set euler to constant():e.
	set preF to (e + cos(theta)) / (1+e*cos(theta)).
	set F to ln(preF+sqrt(preF^2 - 1)).
	set sinhF to (euler^F - euler^-F) / 2.
	set preF0 to (e + cos(theta0)) / (1+e*cos(theta0)).
	set F0 to ln(preF0+sqrt(preF0^2 - 1)).
	set sinhF0 to (euler^F0 - euler^-F0) / 2.
	set nodetime to sqrt(((-a)^3)/k)*((e*sinhF-F)-(e*sinhF0-F0)).
	print nodetime.
	copy warpscript from 0.
	run warpscript(nodetime-90).
	delete warpscript.
	set b2 to true.
	if normalburn {
		set b2 to false.
	}.
	run perf_followcirc(desiredinc,b2).
}.
delete perf_followcirc.
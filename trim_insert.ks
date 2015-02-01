declare parameter targetperiapsis, desiredinc.
set desiredinc1 to desiredinc.
clearscreen.
print "Trimming insertion periapsis to "+(targetperiapsis/1000)+"km at "+desiredinc+" degrees inclination".
//which comes first - periapsis, or crossing the equator?
set degfroman to 360- mod(ship:obt:argumentofperiapsis + ship:obt:trueanomaly,360).
print "Degrees to ascending node: "+round(degfroman).
set degfrompe to 360 - ship:obt:trueanomaly.
print "Degrees to periapsis: "+round(degfrompe).
if degfrompe < degfroman {
	print "Need to do periapsis manoeuvre first - trim periapsis".
	wait 3.
	copy trim_periapsis from 0.
	run trim_periapsis(targetperiapsis).
	delete trim_periapsis.
	print "Now do the circularisation".
	wait 3.
	copy calc_circnode from 0.
	run calc_circnode(targetperiapsis).
	delete calc_circnode.
	copy perf_node from 0.
	run perf_node(false,1,0,0,true,false,false).
	delete perf_node.
	print "Now adjust inclination".
	wait 3.
	copy perf_followinc from 0.
	wait until abs(ship:geoposition:lat) < 1.
	run perf_followinc(desiredinc).
	delete perf_followinc.
} else {
	print "Do inclination change first".
	wait 3.
	copy perf_followinc from 0.
	wait until abs(ship:geoposition:lat) < 1.
	run perf_followinc(desiredinc).
	delete perf_followinc.
	print "Need to do periapsis manoeuvre first - trim periapsis".
	wait 3.
	copy trim_periapsis from 0.
	run trim_periapsis(targetperiapsis).
	delete trim_periapsis.
	print "Now do the circularisation".
	wait 3.
	copy calc_circnode from 0.
	run calc_circnode(targetperiapsis).
	delete calc_circnode.
	copy perf_node from 0.
	run perf_node(false,1,0,0,true,false,false).
	delete perf_node.
}.


declare parameter targetperiapsis.
clearscreen.
print "Trimming intercept periapsis to "+(targetperiapsis/1000)+"km".
print "Check to see if this is on target?!".
//need to see which side of the target we're coming in at!
//get the orbit patch, do a geoposition comparison near periapsis.
set derped to true.
if ship:obt:hasnextpatch {
	if ship:obt:nextpatch:body:name = "Minmus" {
		print "Intercept with right body".
		set derped to false.
		
		//trim obt direction - need to tell which way around the orbit is!
		//let's assume that if the apoapsis of the current orbit is less than the altitude of the planet at time
		//this only works for circular targets at the mo
		set planetalt to orbitat(body("minmus"),time+eta:apoapsis):periapsis.
		set counterclockwise to false.
		if planetalt < ship:apoapsis {
			//planet is closer than ap - probably gonna go counterclockwise
			set counterclockwise to true.
			print "Orbit is counterclockwise...".
		}.
		set n to node (time:seconds+180,0,0,0).
		add n.
		lock neworbit to n:orbit:nextpatch.
		//trim periapsis - at least this is easy.
		if counterclockwise {
			print "... so lower pe to other side".
			//move orbit to other side of planet with retrograde burn.
			until neworbit:periapsis < 0 {
				set n:prograde to n:prograde - 0.01.
			}.
			print "Ok, we're out the other side - raise the pe now".
			until neworbit:periapsis > targetperiapsis {
				print neworbit:periapsis.
				set n:prograde to n:prograde - 0.01.
			}.
		} else {
			print "Clockwise orbit".
			//either raise or lower pe on this side of planet
			if neworbit:periapsis < targetperiapsis {
				print "Raise pe".
				//raise it
				until neworbit:periapsis > targetperiapsis {
					print neworbit:periapsis.
					set n:prograde to n:prograde - 0.01.
				}.
			} else {
				print "Lower pe".
				//lower it
				until neworbit:periapsis < targetperiapsis {
					print neworbit:periapsis.
					set n:prograde to n:prograde + 0.01.
				}.
			}.
		}.
		copy perf_node from 0.
		run perf_node(false,0.01,0,0,true,false,true).
		delete perf_node.
	}.
}.
if derped {
	print "lol you done goofed".
}.
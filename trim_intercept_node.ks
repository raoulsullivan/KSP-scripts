declare parameter tgt, targetperiapsis.
clearscreen.
print "Trimming intercept periapsis to "+(targetperiapsis/1000)+"km".
print "Check to see if this is on target?!".
//need to see which side of the target we're coming in at!
//get the orbit patch, do a geoposition comparison near periapsis.
set n to nextnode.
set derped to true.
if n:orbit:hasnextpatch {
	lock neworbit to n:orbit:nextpatch.
	if neworbit:body:name = tgt {
		print "Intercept with right body".
		set derped to false.
		
		//trim obt direction - need to tell which way around the orbit is!
		//let's assume that if the apoapsis of the current orbit is less than the altitude of the planet at time
		//this only works for circular targets at the mo
		set planetalt to body(tgt):periapsis.
		set clockwise to false.
		if planetalt < n:orbit:apoapsis {
			//planet is closer than ap - probably gonna go clockwise
			set clockwise to true.
			print "Orbit is clockwise...".
		}.
		//trim periapsis - at least this is easy.
		if clockwise {
			print "... so lower pe to other side - make node earlier".
			wait 5.
			//move orbit to other side of planet with retrograde burn.
			until neworbit:periapsis < 0 {
				set n:eta to n:eta - 0.1.
			}.
			print "Ok, we're hitting the planet - raise the pe now".
			wait 5.
			until neworbit:periapsis > targetperiapsis {
				print neworbit:periapsis.
				set n:eta to n:eta - 0.1.
			}.
		} else {
			print "Clockwise orbit".
			//either raise or lower pe on this side of planet
			if neworbit:periapsis < targetperiapsis {
				print "Raise pe - earlier node".
				wait 5.
				//raise it
				until neworbit:periapsis > targetperiapsis {
					print neworbit:periapsis.
					set n:eta to n:eta - 0.1.
				}.
			} else {
				print "Lower pe - later node".
				wait 5.
				//lower it
				until neworbit:periapsis < targetperiapsis {
					print neworbit:periapsis.
					set n:eta to n:eta + 0.1.
				}.
			}.
		}.
	}.
}.
if derped {
	print "lol you done goofed".
}.
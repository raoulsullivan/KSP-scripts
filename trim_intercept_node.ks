declare parameter tgt, targetperiapsis, return.
clearscreen.
print "Trimming intercept periapsis to "+(targetperiapsis/1000)+"km".
print "Check to see if this is on target?!".
//need to see which side of the target we're coming in at!
//get the orbit patch, do a geoposition comparison near periapsis.
set n to nextnode.
set derped to true.
if n:orbit:hasnextpatch {
	if n:orbit:nextpatch:body:name = tgt {
		print "Intercept with right body".
		set derped to false.
		set increment to 0.1.
		//if return {
		//	set increment to -0.1.
		//}.
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
			set done to false.
			until done {
				set n:eta to n:eta - increment.
				if n:orbit:hasnextpatch {
					if n:orbit:nextpatch:periapsis < 0 {
						set done to true.
					}.
				}.
			}.
			print "Ok, we're hitting the planet - raise the pe now".
			wait 5.
			set done to false.
			until done {
				set n:eta to n:eta - increment.
				if n:orbit:hasnextpatch {
					if n:orbit:nextpatch:periapsis > targetperiapsis {
						set done to true.
					}.
				}.
			}.
		} else {
			print "Anticlockwise orbit".
			//either raise or lower pe on this side of planet
			if n:orbit:nextpatch:periapsis < targetperiapsis {
				print "Raise pe - earlier node".
				wait 5.
				//raise it
				set done to false.
				until done {
					set n:eta to n:eta - increment.
					if n:orbit:hasnextpatch {
						if n:orbit:nextpatch:periapsis > targetperiapsis {
							set done to true.
						}.
					}.
				}.
			} else {
				print "Lower pe - later node".
				wait 5.
				//lower it
				set done to false.
				until done {
					set n:eta to n:eta + increment.
					if n:orbit:hasnextpatch {
						if n:orbit:nextpatch:periapsis < targetperiapsis {
							set done to true.
						}.
					}.
				}.
			}.
		}.
	}.
}.
if derped {
	print "lol you done goofed".
}.
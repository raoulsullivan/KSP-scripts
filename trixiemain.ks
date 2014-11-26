clearscreen.
declare parameter step.
print "Mission: TRIXIE!".
print "Destination: Mun".
print "Objective: Sample return and seismic scan".
if step = "0a" {
	print "Step 0a: Launch Trixie 2 (Transfer stage)".
	wait 5.
	copy trixie1 from 0.
	run trixie1(8000,80000,90).
	delete trixie1.
} else {
	print step.
}.
print "NEXT!".
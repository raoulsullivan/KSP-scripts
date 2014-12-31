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
} else if step = "0b" {
	print "Step 0b: Launch Trixie 1 (Landing and return stage)".
	set RCSgroup to ship:partstagged("landerRCSBottom").
	for x in RCSgroup {
		x:getmodule("modulercs"):doevent("disable rcs port").
	}.
	wait 5.
	copy trixie1 from 0.
	run trixie1(15000,80000,90).
	delete trixie1.
} else if step = "1" {
	print "Step 1: Docking".
	wait 5.
	copy trixieintercept from 0.
	run trixieintercept.
	delete trixieintercept.
	copy interceptweak from 0.
	run interceptweak.
	delete interceptweak.
	copy trixiedock from 0.
	run trixiedock.
	delete trixiedock.
} else if step = "2" {
	copy trixieintercept2 from 0.
	run trixieintercept2.
	delete trixieintercept2.
} else if step = "3" {
	copy trixieland from 0.
	run trixieland.
	delete trixieland.
} else if step = "4" {
	copy trixiereturn1 from 0.
	run trixiereturn1.
	delete trixiereturn1.
	copy trixiereturn2 from 0.
	run trixiereturn2.
	delete trixiereturn2.
}.
print "NEXT!".
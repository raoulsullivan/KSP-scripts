clearscreen.
declare parameter step.
print "Mission: JOLEEN!".
print "Destination: Minmus".
print "Objective: Gravity, temperature, pressure survey. Sample return and seismic scan".

if step = "1" {
	print "Step 1: Launch Joleen, weather survey".
	wait 5.
	//launch when minimus ascending node is overhead
	set RCSgroup to ship:partstagged("landerBottomRCS").
	for x in RCSgroup {
		x:getmodule("modulercs"):doevent("disable rcs port").
	}.
	copy joleen1 from 1.
	run joleen1(8000,80000,96).
	delete joleen1.
	clearscreen.
} else if step = "2" {
	print "Step 2: Transfer".
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
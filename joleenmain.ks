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
	copy joleen1 from 0.
	run joleen1(8000,80000,96).
	delete joleen1.
	clearscreen.
} else if step = "2" {
	print "Step 2: Transfer".
	copy joleen2 from 0.
	run joleen2.
	delete joleen2.
	clearscreen.
} else if step = "3" {
	print "Step 3: Orbital science!".
	copy joleen_survey from 0.
	run joleen_survey.
	delete joleen_survey.
	clearscreen.
} else if step = "4" {
	print "Step 4: Landing!".
	copy joleenland from 0.
	run joleenland.
	delete joleenland.
	clearscreen.
} else if step = "5" {
	print "Step 5: Homeward!".
	copy joleenreturn1 from 0.
	run joleenreturn1.
	delete joleenreturn1.
	copy joleenreturn2 from 0.
	run joleenreturn2.
	delete joleenreturn2.
	clearscreen.
}.
print "NEXT!".
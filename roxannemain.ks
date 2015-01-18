clearscreen.
declare parameter step.
print "Mission: ROXANNE!".
print "Destination: Mun".
print "Objective: Crew orbit. Also deliver some satellites and test some parts.".

if step = "1" {
	print "Step 1: Launch, test parts".
	copy roxanne1 from 0.
	run roxanne1(10000,80000,90).
	delete roxanne1.
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
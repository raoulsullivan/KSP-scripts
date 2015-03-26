clearscreen.
declare parameter step.
print "Mission: JULIETTE!".
print "Destination: Mun".
print "Objective: Plant a flag on the Mun.".

if step = "1" {
	print "Step 1: Launch, test parts".
	for x in ship:partsdubbed("transferTop") {
		x:getmodule("modulercs"):doevent("disable rcs port").
	}.
	for x in ship:partsdubbed("landerTop") {
		x:getmodule("modulercs"):doevent("disable rcs port").
	}.
	copy juliette1 from 0.
	run juliette1(10000,80000,90).
	delete juliette1.
	clearscreen.
} else if step = "2" {
	print "Step 2: Transfer".
	copy juliette2 from 0.
	run juliette2.
	delete juliette2.
	clearscreen.
} else if step = "3" {
	print "Step 3: Landing!".
	//Do survey
	copy julietteland from 0.
	run julietteland.
	delete julietteland.
} else if step = "4" {
	print "Go home!".
	copy juliette4a from 0.
	run juliette4a.
	delete juliette4a.
	clearscreen.
} else if step = "5" {
	print "Go home!".
	copy juliette5a from 0.
	run juliette5a.
	delete juliette5a.
	copy juliette5b from 0.
	run juliette5b.
	delete juliette5b.
	clearscreen.
}.
print "NEXT!".
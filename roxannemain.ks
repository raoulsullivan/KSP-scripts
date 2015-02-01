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
	copy roxanne2 from 0.
	run roxanne2.
	delete roxanne2.
	clearscreen.
} else if step = "3" {
	print "Step 3: Orbital science!".
	//Do survey
	copy perf_survey from 0.
	run perf_survey("Mk1-2 command pod","btsmmodulesciencezonedisplay","biome","btsmmodulecrewreport","crew report").
	delete perf_survey.
} else if step = "4" {
	print "Go home!".
	copy roxanne3 from 0.
	run roxanne3.
	delete roxanne3.
	clearscreen.
}.
print "NEXT!".
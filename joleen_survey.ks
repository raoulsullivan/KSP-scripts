//joleen mission polar insertion thing
print "Whut".
set sr to ship:partsdubbed("grav1")[0].
set modulename to "BTSMModuleScienceZoneDisplay".
set fieldname to "biome".
set modulename2 to "BTSMModuleScienceExperiment".
set eventname to "log gravity data".
lock biome to sr:getmodule(modulename):getfield(fieldname).
until biome = "poles" {
	wait 1.
}.
sr:getmodule(modulename2):doevent(eventname).
set degfroman to 360- mod(ship:obt:argumentofperiapsis + ship:obt:trueanomaly,360).
print "Degrees to ascending node: "+round(degfroman).
set normalburn to false.
if degfroman > 180 {
	print "Descending node is closer".
	set degfroman to degfroman - 180.
	set normalburn to true.
}.
set timetoan to ship:obt:period * (degfroman)/360.
copy warpscript from 0.
run warpscript(timetoan-90).
delete warpscript.
copy perf_followcirc from 0.
run perf_followcirc(0,normalburn).
delete perf_followcirc.
copy perf_survey from 0.
run perf_survey.
delete perf_survey.
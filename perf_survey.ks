//biome gravity survey
//assumes eastward orbit
set startlong to ship:geoposition:lng.
set sr to ship:partsdubbed("grav1")[0].
set modulename to "BTSMModuleScienceZoneDisplay".
set fieldname to "biome".
set modulename2 to "BTSMModuleScienceExperiment".
set eventname to "log gravity data".
lock biome to sr:getmodule(modulename):getfield(fieldname).
set donebiomes to list().
//TODO - fix this end condition!
set done to false.
until done {
	if donebiomes:contains(biome) <> "True" {
		set warp to 0.
		donebiomes:add(biome).
		sr:getmodule(modulename2):doevent(eventname).
		print donebiomes.
	}.
	when ship:geoposition:lng < startlong then {
		when ship:geoposition:lng > startlong then {
			set done to true.
		}.
	}.
}.
set warp to 0.
print "Done 1 orbit".
//generic survey
//assumes eastward orbit
declare parameter sciencepartname, biomemodulename, biomefieldname, experimentmodulename, experimenteventname.
set startlong to ship:geoposition:lng.
set sr to ship:partsdubbed(sciencepartname)[0].
lock biome to sr:getmodule(biomemodulename):getfield(biomefieldname).
set donebiomes to list().
//TODO - fix this end condition!
set done to false.
until done {
	if donebiomes:contains(biome) <> "True" {
		set warp to 0.
		donebiomes:add(biome).
		sr:getmodule(experimentmodulename):doevent(experimenteventname).
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
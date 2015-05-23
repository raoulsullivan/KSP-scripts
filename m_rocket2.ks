function read_pressure {
	print ("Reading pressure at "+round(altitude)+"m").
	set barometer to ship:partstagged("barometer")[0].
	set barometer_experiment to barometer:getmodule("BTSMModuleScienceExperiment").
	barometer_experiment:doevent("log pressure data").
}
stage.
when altitude > 15100 then {
	read_pressure().
	when altitude > 27600 then {
		read_pressure().
	}
}
when stage:solidfuel = 0 then {
	stage.
	when stage:solidfuel = 0 then {
		stage.
	}
}
wait 600. 
print "PERF_ALIGNMENT".
copy PIDsetup from 0.
run PIDsetup(0.1,1,0.1,1,0.1,1,1,1,1).
delete PIDsetup.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set onTarget to false.
rcs on.
until onTarget {
	run PID1(rcspower, rcspower, 0).
	wait 0.1.
}.
set ship:control:yaw to 0.
set ship:control:pitch to 0.
set ship:control:roll to 0.
set ship:control:fore to 0.
rcs off.
set warp to 1.
wait 5.
set warp to 0.
delete PID1.
print "PERF_ALIGNMENT DONE".
wait 5.
clearscreen.
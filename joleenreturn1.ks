//joleenreturnlaunch
lock df to up.
rcs on.
lock throttle to 0.3.
when altitude > 10 then {
	lock df to prograde.
}
when apoapsis > 20000 then {
	set done to true.
}.

copy pidsetup from 0.
run pidsetup(0.1,1,0.1,1,0.1,1,1,1,5).
delete pidsetup.
copy PID1 from 0.
lock rcspower to ship:mass/100.
set done to false.
until done {
	run pid1(rcspower,rcspower,rcspower).
}
delete PID1.
lock throttle to 0.

//circularise
copy calc_circnode from 0.
run calc_circnode(20000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,0.5,0,0,true,false,false).
delete perf_node.
set LanderBatterygroup to ship:partstagged("landerBattery").
for x in LanderBatterygroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", false).
}.
copy calc_interceptnode from 0.
run calc_interceptnode("Mun").
set warp to 3.
set ttime to time + nextnode:eta - 350.
wait until time > ttime.
set warp to 0.
wait 5.
copy trixie_transfer_setup from 0.
run trixie_transfer_setup.
delete trixie_transfer_setup.
remove nextnode.
wait 5.
run calc_interceptnode("Mun").
delete calc_interceptnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true,true).
delete perf_node.
copy trim_intercept from 0.
run trim_intercept(30000).
delete trim_intercept.
set warp to 5.
wait until ship:obt:body:name = "Mun".
set warp to 0.
copy calc_circnode from 0.
run calc_circnode(ship:periapsis).
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false).
delete perf_node.
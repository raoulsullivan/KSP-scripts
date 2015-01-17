//Match inclination
copy baldevinc from 0.
run baldevinc("minmus").
delete baldevinc.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,true).
delete perf_node.
clearscreen.
//Intercept
copy calc_interceptnode from 0.
run calc_interceptnode("Minmus").
copy warpscript from 0.
run warpscript(nextnode:eta - 350).
delete warpscript.
remove nextnode.
run calc_interceptnode("Minmus").
delete calc_interceptnode.
clearscreen.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
//Trim
copy trim_intercept from 0.
run trim_intercept(200000).
delete trim_intercept.
//Coast
copy warpscript from 0.
run warpscript(ETA:TRANSITION + 300).
delete warpscript.
//Circularise
copy trim_insert from 0.
run trim_insert(20000,80).
delete trim_insert.
//get captchad
copy calc_circnode from 0.
run calc_circnode(targetperiapsis).
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
copy warpscript from 0.
run warpscript(300).
delete warpscript.
//circularise
copy calc_circnode from 0.
run calc_circnode(targetperiapsis).
delete calc_circnode.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
//Trim inclination
copy baldevinc from 0.
run baldevinc("Mun").
delete baldevinc.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
//Intercept
copy calc_interceptnode from 0.
run calc_interceptnode("Mun",900).
copy warpscript from 0.
run warpscript(nextnode:eta - 350).
delete warpscript.
remove nextnode.
run calc_interceptnode("Mun",900).
delete calc_interceptnode.
clearscreen.
//adjust the node
copy trim_intercept_node from 0.
run trim_intercept_node("Mun",20000).
delete trim_intercept_node.
//do it
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
//Coast
copy warpscript from 0.
run warpscript(ETA:TRANSITION + 300).
delete warpscript.
//Final trim
copy trim_insert from 0.
run trim_insert(20000,0).
delete trim_insert.
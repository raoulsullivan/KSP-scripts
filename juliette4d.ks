clearscreen.
copy juliettemunarlaunch from 0.
run juliettemunarlaunch.
delete juliettemunarlaunch.
//circularise
copy calc_circnode from 0.
run calc_circnode(20000).
delete calc_circnode.
copy perf_node from 0.
run perf_node(true,1,0,0,true,false,false).
delete perf_node.
//incline
copy perf_intercept_inclination from 0.
run perf_intercept_inclination.
delete perf_intercept_inclination.
//and the rest
copy julietteintercept from 0.
run julietteintercept.
delete julietteintercept.
copy interceptweak from 0.
run interceptweak.
delete interceptweak.
copy juliettedock from 0.
run juliettedock.
delete juliettedock.
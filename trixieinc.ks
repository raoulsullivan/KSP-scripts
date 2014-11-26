//fix inclination
run calc_incnode(0).
add nodex.
run perf_node(false,1,8,5).
run calc_circnode(80000).
add nodex.
run perf_node(true,1,8,5).
run calc_circnode(80000).
add nodex.
run perf_node(true,1,8,5).
print "OK".



clearscreen.
print "TRIXIE CIRC CALLED".
set desiredalt to ship:periapsis.
run calc_circnode(ship:periapsis).
run perf_node(true,1,8,0).
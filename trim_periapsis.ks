declare parameter targetperiapsis.
set nd to node(time:seconds + 180, 0, 0, 0).
add nd.
lock nextpe to nd:orbit:periapsis.
if targetperiapsis < nextpe {
	print "Lower periapsis".
	until targetperiapsis > nextpe {
		set nd:radialout to nd:radialout - 0.1.
	}.
} else {
	print "Raise periapsis".
	until targetperiapsis < nextpe {
		set nd:radialout to nd:radialout + 0.1.
	}.
}.
copy perf_node from 0.
run perf_node(false,1,0,0,true,false,false).
delete perf_node.
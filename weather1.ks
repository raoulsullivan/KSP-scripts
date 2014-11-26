print "1".
wait 1.
lock steering to up + R(0,0,180).
stage.
print "Launch!".
print stage:solidfuel.
wait 10.
print stage:solidfuel.
when stage:solidfuel < 260 then {print "Stage 2!". stage.}.
wait until altitude > 30001.
print "SCIENCE MO4R!".
toggle AG1.
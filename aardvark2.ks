print "3".
wait 1.
print "2".
wait 1.
print "1".
wait 1.
stage.
print "Launch!".
print stage:solidfuel.
when stage:solidfuel < 260 then {print "Stage 2!". stage. when stage:solidfuel < 1 then {print "Stage 3!". stage.}.}.
wait until altitude > 12501.
print "SCIENCE!".
toggle AG1.
wait until altitude > 30001.
print "SCIENCE MO4R!".
toggle AG2.
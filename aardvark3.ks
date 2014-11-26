print "1".
wait 1.
lock steering to up + R(0,0,180).
stage.
print "Launch!".
print stage:solidfuel.
when stage:solidfuel < 111 then {
	print "Stage 2!". 
	stage.
	print stage:solidfuel.
	when stage:solidfuel < 10 then {
		print "Stage 3!".
		stage.
		print stage:solidfuel.
		when stage:solidfuel < 10 then {
			print "Stage 4!".
			stage.
			print stage:solidfuel.
			when stage:solidfuel < 10 then {
				print "Stage 5!".
				stage.
				print stage:solidfuel.
			}.
		}.
	}.
}.
wait until altitude > 70001.
print "SCIENCE!".
toggle AG1.
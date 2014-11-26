print "1".
wait 1.
lock steering to up.
stage.
print "Launch!".
print stage:solidfuel.
when altitude > 10000 then {
	lock steering to up + R(0,-10,0).
}.
//1000
until false {print stage:solidfuel.}.

when stage:solidfuel < 510 then {
	//1239
	print "Stage 2!". 
	stage.
	print stage:solidfuel.
	when stage:solidfuel < 750 then {
		print "Stage 3!".
		stage.
		print stage:solidfuel.
		when stage:solidfuel < 624 then {
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
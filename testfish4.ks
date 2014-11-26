lock aAP to ship:apoapsis.
lock aPE to ship:periapsis.
lock aSMA to ship:obt:SEMIMAJORAXIS.
lock aV to velocity:orbit:mag.
set bd to body("kerbin").

lock aOP to (2*constant():PI)*sqrt(aSMA^3/(constant():g*bd:mass)).
lock aMM to (24*60*60)*sqrt((constant():g*bd:mass)/(4*(constant():PI)^2*aSMA^3)).
lock aOP2 to (24*60*60)/aMM.
lock aMM2 to (2*constant():pi)/ship:obt:period.
lock aMA to ship:obt:MEANANOMALYATEPOCH.
lock orbitalcompletion to aMA/(2*constant():pi).
lock timetoperiapse to (ship:obt:period*(1-(orbitalcompletion))).
lock orbitalcompletion2 to 0.5+orbitalcompletion-floor(orbitalcompletion/0.51).
lock timetoapoapse to (ship:obt:period*(1-(orbitalcompletion2))).

lock A0 to ship:obt:SEMIMAJORAXIS * ship:obt:SEMIMINORAXIS * constant():pi.
lock angularSpeeed to sqrt((constant():g*bd:mass)/aSMA^3).


clearscreen.

set desiredpe to 150000.
print("Desired periapsis: "+desiredpe) at (0,15).
set deltape to desiredpe - ship:periapsis.
print("Delta PE: "+deltape) at (0,16).
set currentaltrad to ship:apoapsis + bd:radius.
print("Apoapsis radius: "+currentaltrad) at (0,17).
set desiredSMA to ship:obt:semimajoraxis + (deltape/2).
print("Current SMA: "+ship:obt:semimajoraxis ) at (0,18).
print("Desired SMA: "+desiredSMA ) at (0,19).
set desiredvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/desiredSMA))).
print("Desired velocity at AP: "+desiredvelocityatap) at (0,21).
set currentvelocityatap to sqrt((constant():g*bd:mass)*((2/currentaltrad)-(1/ship:obt:semimajoraxis))).
print("Current velocity at AP: "+currentvelocityatap) at (0,20).
set desireddv to desiredvelocityatap -currentvelocityatap.
print("Delta V: "+ desireddv) at (0,22).


set x to node (time:seconds+timetoapoapse,0,0,desireddv).
add x.


list engines in enginelist.
set isp to enginelist[0]:isp.
set mfinal to ship:mass/(constant():e^(desireddv/(isp * 9.8066))).
set mchange to (ship:mass - mfinal) * 1000.
print("Mass change: "+ mchange) at (0,23).
set mdot to ship:maxthrust*0.1*1000/(isp * 9.8066).
print("mDot: "+mdot) at(0,24).
set burntime to mchange/mdot.
print("Burn time: "+burntime) at(0,25).
set burnstart to x:eta+time - (burntime/2).
print("Burn start: "+burntime) at(0,25).
set burnstop to burnstart + burntime.
lock timetoburn to time - burnstart.
when time >= burnstart then {
	lock throttle to 0.1. 
	when time >= burnstop then {
		lock throttle to 0.
	}.
}.



print "Actual Orbital Period:".
print "Actual Mean Motion:".
until 0 {
	print (aOP) at (23,0).
	print (aMM) at (23,1).
	print (aOP2) at (23,2).
	print (aMM2) at (23,3).
	print (ship:obt:TRUEANOMALY) at (23,4).
	print ("Actual Mean Anomaly: "+aMA) at (0,5).
	print ("Orbital completion: "+orbitalcompletion) at (0,6).
	print ("Time to Periapse: "+timetoperiapse/60) at (0,7).
	print ("Orbital completion2: "+orbitalcompletion2) at (0,11).
	print ("Time to Apoapse: "+timetoapoapse/60) at (0,8).
	print ("Time to burn: "+timetoburn) at (0,26).
	wait 0.1.
}.
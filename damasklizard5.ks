set target to body("mun").
set step to "waiting".

set initialmass to ship:mass*1000.
set finalmass to initialmass - ((stage:LiquidFuel + stage:Oxidizer)*5).
set isp to 380.
set dv to (isp * 9.8066)*ln(initialmass/finalmass).
print dv.

set bd to body("Kerbin").
set u to (constant():g*bd:mass).
lock currentradius to ship:obt:apoapsis + bd:radius.
set currentvelocityatap to sqrt(u*((2/currentradius)-(1/ship:obt:semimajoraxis))).
set newvelocityatap to currentvelocityatap+dv.
set newsma to 1/((2/currentradius)- ((newvelocityatap^2)/u)).
set newe to ((currentradius/newsma)-1)*-1.
print ("New ecc: "+newe).
set newp to newsma*(1-newe^2).
print ("New semi-latus rectum: "+newp).

set r to 12000000.
set targettrue to arccos((newp / r -1)/newe).
print ("Target true anomaly: "+targettrue).

set targetecc to (newe + cos(targettrue)) / (1 + (newe * cos(targettrue))).
print ("Target eccentric anomaly: "+targetecc).
set targetecc to ln(targetecc + sqrt(targetecc^2 -1)).
print ("Target eccentric anomaly: "+targetecc).
print ("Target eccentric anomaly: "+targetecc).

set e to constant():e.
set sinhtargetecc to (e^targetecc - e^-targetecc)/2.
print ("sinh of target eccentric anomaly: "+sinhtargetecc).
set targetmean to newe * sinhtargetecc - targetecc.
print ("Target mean anomaly: "+targetmean).

set timetotarget to ((-newsma^3 / u)^0.5) * targetmean.
print ("Time to target (mins): "+timetotarget/60).
lock shippos to mod((ship:obt:lan + ship:obt:argumentofperiapsis + ship:obt:trueanomaly),360).
lock targetpos to mod((target:obt:lan + target:obt:argumentofperiapsis + target:obt:trueanomaly),360).
print ("Target orbital position: "+targetpos).
set phaseangle to targetpos-shippos.
if (phaseangle < 0) { set phaseangle to 360+phaseangle.}.
print ("Phase angle: "+phaseangle).
lock xferoffset to mod(((timetotarget/target:obt:period)*360),360).
lock departureangle to targettrue - xferoffset.
print ("Departure angle: "+departureangle).
set departurediff to phaseangle - departureangle.
if (departurediff < 0) {set departurediff to 360+departurediff.}.
print ("Departure diff: "+departurediff).
set timetoxfer to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer).
set waitingoffset to mod(((timetoxfer/target:obt:period)*360),360).
set departurediff to departurediff + waitingoffset.
print ("Departure diff: "+departurediff).
set timetoxfer2 to ship:obt:period*(departurediff/360).
print ("Time until depart: "+timetoxfer2).
set x to node (time:seconds+timetoxfer2,0,0,dv).
add x.
print ("done").
lock tH to x:BURNVECTOR:DIRECTION+ R(0,0,90).
set kpr to 0.01.
set kdr to 0.1.
set kpy to 0.01.
set kdy to 0.1.
set kpp to 0.01.
set kdp to 0.1.
set er to 0.
set ep to 0.
set ey to 0.
set rE to 0.
set pE to 0.
set yE to 0.
lock topUnit to ship:facing*R(-90,0,0):Vector.
lock starUnit to ship:facing*R(0,90,0):Vector.
lock fwdUnit to ship:facing*R(0,0,-90):Vector.
lock pitchOff to 90*VDOT(tH:vector,topUnit).
lock yawOff to 90*VDOT(tH:vector,starUnit).
lock rotOff to 90*VDOT(tH:vector,fwdUnit).
set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"Desired heading",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Starboard",4,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Top",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"Forward",4,true).
set mfinal to ship:mass/(constant():e^(dv/(isp * 9.8066))).
set mchange to (ship:mass - mfinal) * 1000.
set mdot to ship:maxthrust*1*1000/(isp * 9.8066).
set burntime to mchange/mdot.
print("Burn time: "+burntime) at(0,10).
set burnstart to x:eta+time - (burntime/2).
print("Burn start: "+burnstart) at(0,11).
set burnstop to burnstart + burntime.
print("Burn stop: "+burnstop) at(0,12).
set timetoburn to time - burnstart.
when time >= burnstart-30 then {set step to "Align". Toggle RCS.}.
when time >= burnstart then {
	set step to "Injection burn".
	lock throttle to 1. 
	when time >= burnstop then {
		lock throttle to 0.
		Toggle RCS.
		set step to "Coast".
		when ship:obt:body = "Mun" then {
			toggle AG1.
			toggle AG2.
			when ship:altitude < 50000 then {
				toggle AG1.
				toggle AG2.
			}
		}.
	}.
}.
until 0 {
	print (step) at (0,0).
	set vd0:vec to tH:vector.
	set vd1:vec to starUnit.
	set vd2:vec to topUnit.
	set vd3:vec to fwdUnit.
	set rTarget to tH:Roll - 180.
	set lRE to rE.
	set rE to ship:facing:Roll - rTarget.
	if rE > 180 {set rE to (360 - rE)* -1.}.
	set ship:control:roll to (kpr * rE)+(kdr*(rE - lRE)).
	set lPE to pE.
	set pE to pitchOff.
	if pE > 180 {set pE to (360 - pE) * -1.}.
	set ship:control:pitch to (kpp * pE)+(kdp*(pE - lPE)).
	set lYE to yE.
	set yE to yawOff.
	if yE > 180 {set yE to (360 - yE) * -1.}.
	set ship:control:Yaw to (kpy * yE)+(kdy*(yE - lYE)).
	wait 0.1.
}.
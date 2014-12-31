//intercepts the other spaceship
clearscreen.
print "TRIXIE INTERCEPT CALLED".
set bd to ship:obt:body.
set k to constant():g * bd:mass.

//need to know how long the tgt will take to complete this phase angle - i.e. how long for true anomaly to change
set e to ship:obt:eccentricity.
print e.

set tgttruea to ship:obt:TRUEANOMALY.
print "ship true anomaly: "+tgttruea.
set tgtmeana to ship:obt:MEANANOMALYATEPOCH.
print "ship mean anomaly: "+tgtmeana.
set tgtecca to arccos((e+cos(tgttruea))/(1 + e * cos(tgttruea))).
print "ship eccentric anomaly: "+tgtecca.

set tgtmeana3 to tgtecca - ((180/constant():pi)*e*sin(tgtecca)).
set tgtmeana3 to tgtmeana3 / (180/constant():pi).
print "Ship mean anomaly: "+tgtmeana3.
print "----".
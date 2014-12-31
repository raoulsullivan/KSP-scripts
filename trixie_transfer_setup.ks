set landerMonopropgroup to ship:partstagged("landerMonoprop").
for x in landerMonopropgroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", false).
}.
set RCSgroup to ship:partstagged("landerRCSBottom").
for x in RCSgroup {
	x:getmodule("modulercs"):doevent("disable rcs port").
}.
set RCSgroup to ship:partstagged("transferRCSTop").
for x in RCSgroup {
	x:getmodule("modulercs"):doevent("disable rcs port").
}.
set transferBatterygroup to ship:partstagged("transferBattery").
for x in transferBatterygroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle electricity", true).
}.
set transferMonopropgroup to ship:partstagged("transferMonoprop").
for x in transferMonopropgroup {
	x:getmodule("btsmmoduleresourceactiontoggle"):doaction("toggle rcs fuel", true).
}.
stage.
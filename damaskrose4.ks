//just the science
set lats to list().
set lats:add to -174.
set lats:add to -169.
set lats:add to -168.
set lats:add to -167.
set lats:add to -165.
set lats:add to -129.
set lats:add to -92.3.
set lats:add to -55.
set lats:add to 15.
set lats:add to 79.
set lats:add to 137.
for var in lats {
	until ship:longitude > var {
		wait 1.
		print ("Waiting for "+var+"    ") at (0,0).
		print ("Currently at "+ship:longitude+"    ") at (0,1).
	}.
	toggle AG1.	
}.
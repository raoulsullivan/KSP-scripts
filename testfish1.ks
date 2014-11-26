set vd0 to vecdrawargs(v(0,0,0),v(1,0,0),red,"prograde",10,true).
set vd1 to vecdrawargs(v(0,0,0),v(1,0,0),blue,"flat",10,true).
set vd2 to vecdrawargs(v(0,0,0),v(1,0,0),green,"addition",4,true).
set vd3 to vecdrawargs(v(0,0,0),v(1,0,0),green,"subtraction(pgv-flv)",4,true).
set vd4 to vecdrawargs(v(0,0,0),v(1,0,0),green,"subtraction(flv-pgv)",4,true).
set vd5 to vecdrawargs(v(0,0,0),v(1,0,0),green,"dotproduct",4,true).
set vd6 to vecdrawargs(v(0,0,0),v(1,0,0),green,"crossproduct(pgv,flv)",4,true).
set vd7 to vecdrawargs(v(0,0,0),v(1,0,0),green,"crossproduct(flv,pgv)",4,true).
set vd8 to vecdrawargs(v(0,0,0),v(1,0,0),green,"vexclude(pgv,flv)",4,true).
set vd9 to vecdrawargs(v(0,0,0),v(1,0,0),green,"vexclude(flv,pgv)",4,true).
set vd10 to vecdrawargs(v(0,0,0),v(1,0,0),white,"go",10,true).

until 0 {
	clearscreen.
	lock pgv to ship:prograde:vector.
	lock flv to heading(90,0):vector.
	lock des to heading(90,0-VANG(flv,pgv)):vector.
	set vd10:vec to des.
	set vd0:vec to pgv.
	set vd1:vec to flv.
	set addv to flv+pgv.
	set subtrv1 to flv-pgv.
	set subtrv2 to pgv-flv.
	set dotv to pgv*flv.
	set crossv1 to VECTORCROSSPRODUCT(pgv,flv).
	set crossv2 to VECTORCROSSPRODUCT(flv,pgv).
	set exc1 to VECTOREXCLUDE(pgv,flv).
	set exc2 to VECTOREXCLUDE(flv,pgv).
	set vd2:vec to addv.
	set vd3:vec to subtrv1.
	set vd4:vec to subtrv2.
	set vd5:vec to dotv.
	set vd6:vec to crossv1.
	set vd7:vec to crossv2.
	set vd8:vec to exc1.
	set vd9:vec to exc2.
	print VANG(pgv,flv).
	print VANG(flv,pgv).
	wait 1.
}.
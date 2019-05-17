use <deps.link/gears/gears.scad>
use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/erhannisScad/misc.scad>

/*
//total number of teeth around the entire perimeter
n1 = 11;  //red gear number of teeth
n5 = 8;   //gray rack

//gear variables
mm_per_tooth   = 9;   //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
d1 = pitch_radius(mm_per_tooth, n1);


// Red Gear
mirror(v=[0, 0, 1]) translate([ 0,  0, 0]) rotate([0, 0,  $t * 360 / n1]) color([1.00, 0.75, 0.75]) gear(mm_per_tooth=9, numberOfTeeth=11, thickness=20, hole_diameter=0, twist=0, teeth_to_hide=0, pressure_angle=28, clearance=0, backlash=0);

// Rack
translate([(-floor(n5 / 2) - floor(n1 / 2) + $t + n1 / 2 - 1 / 2) * 9, -d1 + 0.0, 0]) rotate([0, 0, 0]) color([0.75, 0.75, 0.75]) rack(mm_per_tooth=9, numberOfTeeth=8, thickness=20, height=12, pressure_angle=28, backlash=0); //TODO Add clearance


rack(mm_per_tooth=9, numberOfTeeth=8, thickness=20, height=12, pressure_angle=28, backlash=0); //TODO Add clearance
*/

//nema17_mount_holes(depth=10, l=0, slop=0, $fn=60);
//nema17_stepper($fn=60,shaft=20);
flattedShaft(h=40,r=5,$fn=60);

//gear(mm_per_tooth=4,number_of_teeth=10,thickness=5);
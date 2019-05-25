use <deps.link/gears/gears.scad>
use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/moreGears/Getriebe.scad>

$fn=60;

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
//flattedShaft(h=40,r=5,$fn=60);

function sqr(x) = x * x;

function get_modul(desired_thread_width, gangzahl, radius) = sqrt(1 / (sqr(gangzahl)*((1/(4*sqr(radius)))+(sqr(PI)/sqr(desired_thread_width)))));

function get_steigungswinkel(desired_thread_width, modul, gangzahl) = acos((PI*modul*gangzahl)/desired_thread_width);

echo(outer_radius(mm_per_tooth=4.2,number_of_teeth=10,clearance=0.1));

/*
translate([40,0,0])
difference() {
  gear(mm_per_tooth=4.2,number_of_teeth=10,clearance=0.1,thickness=5);
  flattedShaft(h=40,r=2.5,center=true);
}
*/

//modul = 0.575;
gangzahl = 1;
//desired_thread_width = 1.78;//2.08;
desired_thread_width = 2.08;
modul = get_modul(desired_thread_width, gangzahl, 25);
//lead_angle = 1;
//lead_angle = 0.66;
//lead_angle = //29.7;//150.281; 
lead_angle = get_steigungswinkel(desired_thread_width=desired_thread_width, modul=modul, gangzahl=gangzahl);
p_angle = 30;

union() {
  echo("modul", modul);
  echo("lead_angle", lead_angle);
  steigungswinkel = lead_angle;
  eingriffswinkel = p_angle;
  laenge = 20;
  rad = 360 / (2 * PI);

	c = modul / 6;												// Kopfspiel
  echo("c", c);
	r = modul*gangzahl/(2*sin(steigungswinkel));				// Teilzylinder-Radius
  echo("r", r);
	rf = r - modul - c;											// Fußzylinder-Radius
  echo("rf", rf);
	a = modul*gangzahl/(90*tan(eingriffswinkel));				// Spiralparameter
  echo("a", a);
	tau_max = 180/gangzahl*tan(eingriffswinkel);				// Winkel von Fuß zu Kopf in der Normalen
  echo("tau_max", tau_max);
	gamma = -rad*laenge/((rf+modul+c)*tan(steigungswinkel));	// Torsionswinkel für Extrusion
  echo("gamma", gamma);
}
/*
modul = height of the thread above the pitch circle
gangzahl = number of threads
laenge = length of the worm
bohrung = central bore diameter
eingriffswinkel = pressure angle, standard value = 20° according to DIN 867
steigungswinkel = lead angle of worm. Positive lead angle = clockwise thread rotation
zusammen_gebaut = assembled (true) or disassembled for printing (false)
*/
/*
translate([0,10,0])
//rotate([0,90,0])
difference() {
  schnecke(modul=modul, gangzahl=gangzahl, laenge=20, bohrung=0, eingriffswinkel=p_angle, steigungswinkel=lead_angle, zusammen_gebaut=true);
  flattedShaft(h=FOREVER,r=2.5+0.1,center=true);
}
*/
/*
modul = height of the tooth above the pitch line
laenge = length of the rack
hoehe = height from bottom to the pitch line
breite = face width
eingriffswinkel = pressure angle, standard value = 20° according to DIN 867. Should not be greater than 45°.
schraegungswinkel = bevel angle perpendicular to the rack's length; 0° = straight teeth
*/
/*
mirror([0,0,1])
zahnstange(modul=modul, laenge=50, hoehe=20, breite=10, eingriffswinkel=p_angle, schraegungswinkel=lead_angle);
*/

/*
D=10;
H=3;
for (i=[0,1,2,3,4]) {
  translate([(D+2)*i,0,0]) {
    difference() {
      cylinder(d=D,h=H);
      //flattedShaft(r=1.5+(i*0.05), h=H);
      cylinder(r=1.5+(i*0.05), h=H);
    }
  }
}
*/

/**
Negative mmPerRev for reverse orientaton
Outer ys = ys + o
Inner ys = ys - o
slop is added to o of worm used to cut rack
*/
module worm_rack(xs = 10, ys = 15, z = 20, worm_diam = 50, o = 1, mmPerRev = 2) {
  difference() {
    cube([xs, ys+o, z]);
    translate([xs/2, ys + worm_diam/2, 0])
      worm(h = z, d = worm_diam, o = o, mmPerRev = mmPerRev);
  }
}

// Meshing cutaway
/*
difference() {
  union() {
    $fn = 100;
    xs = 10;
    ys = 15;
    z = 20;
    worm_diam = 50;
    o = 1;
    mmPerRev = 2;
    slop = 0.5;
    difference() {
      worm_rack(slop=slop);
      translate([-95,0,0])
        cube([100,100,100]);
      translate([5.5,0,0])
        cube([100,100,100]);
    }
    translate([0.5,0,0])
    difference() {
      translate([xs/2, ys + worm_diam/2, 0])
        worm(h = z, d = worm_diam, o = o, mmPerRev = mmPerRev);
      translate([-95,0,0])
        cube([100,100,100]);
      translate([5.5,0,0])
        cube([100,100,100]);
    }
  }
}
*/

/**
Negative mmPerRev for reverse orientaton
Outer diameter = d + 2o
Inner diameter = d - 2o
*/
module worm(h = 20, d = 50, o = 1, mmPerRev = 2) {
  twist = 360 * h / mmPerRev;
  linear_extrude(height = h, center = false, convexity = 10, twist = twist)
  translate([o, 0, 0])
  circle(d=d);
}

{
  FOREVER = 1000;
  SYRINGE_HOLE_DIAM = 18.5;
  SYRINGE_DIAM = 16.5;
  SYRINGE_LENGTH = 76;
}


GEAR_OFFSET = 1;
WORM_DIAM = 50;
WORM_HEIGHT = 20;
MM_PER_REV = 2.08;
/*
difference() { // Worm
  worm(h = 20, d = WORM_DIAM, o = GEAR_OFFSET, mmPerRev = MM_PER_REV);
  flattedShaft(h=40,r=2.5,center=true);
}
*/

RACK_SIZE_X = 7;
RACK_SIZE_Y = 7 + GEAR_OFFSET;
RACK_OVERHANG_SIZE_X = RACK_SIZE_X;
RACK_OVERHANG_SIZE_Y = 20;
RACK_OVERHANG_LEDGE_Z = RACK_OVERHANG_SIZE_X;
RACK_OVERHANG_SIZE_Z = RACK_OVERHANG_SIZE_Y + RACK_OVERHANG_LEDGE_Z;
RACK_SIZE_Z = SYRINGE_LENGTH + RACK_OVERHANG_SIZE_Z + 15;


union() { // Plunger
  if (true) {
  worm_rack(xs = RACK_SIZE_X, ys = RACK_SIZE_Y - GEAR_OFFSET, z = RACK_SIZE_Z, worm_diam = WORM_DIAM, o = GEAR_OFFSET, mmPerRev = MM_PER_REV);
  } else {
    cube([RACK_SIZE_X, RACK_SIZE_Y, RACK_SIZE_Z]);
  }
  translate([0,-RACK_OVERHANG_SIZE_Y,RACK_SIZE_Z-RACK_OVERHANG_SIZE_Z]) {
    difference() {
      cube([RACK_OVERHANG_SIZE_X, RACK_OVERHANG_SIZE_Y, RACK_OVERHANG_SIZE_Z]);
      translate([0,0,RACK_OVERHANG_LEDGE_Z])
      rotate([45,0,0])
        cube(FOREVER);
    }
  }
}

/*
{ // Main block
  PLATE_SIZE_X = 28;
  PLATE_SIZE_Y = 100;
  PLATE_SIZE_Z = 5;
  
  BLOCK_SIZE_X = PLATE_SIZE_X;
  BLOCK_SIZE_Y = 35;
  BLOCK_SIZE_Z = 52;
  
  BRACE_SIZE_X = BLOCK_SIZE_X;
  BRACE_SIZE_Y = RACK_SIZE_Y;
  BRACE_SIZE_Z = RACK_SIZE_Z + 10;
  BRACE_TWEAK_Z = -35;
  
  SLOP = 1;
  
  MOTOR_SIZE_Z = 40;
  difference() {
    union() {
      translate([0,0,BLOCK_SIZE_Z/2 + PLATE_SIZE_Z])
        cube([BLOCK_SIZE_X, BLOCK_SIZE_Y, BLOCK_SIZE_Z], center=true);
      translate([-PLATE_SIZE_X/2, -PLATE_SIZE_Y/2, 0])
        plate();
      skip() { //TODO Wait, this can't really hang out in space like that.
        MOTOR_PLATE_THICKNESS = 7;
        MOTOR_WIDTH = nema_motor_width(17);
        translate([0,(MOTOR_WIDTH+BLOCK_SIZE_Y)/2,MOTOR_SIZE_Z+PLATE_SIZE_Z+5]) {
          difference() {
            cube([MOTOR_WIDTH,MOTOR_WIDTH,MOTOR_PLATE_THICKNESS], center=true);
            nema17_mount_holes(depth=MOTOR_PLATE_THICKNESS, l=0, slop=0);
          }
        }
      }
      translate([0,BLOCK_SIZE_Y/2,BLOCK_SIZE_Z+PLATE_SIZE_Z+RACK_SIZE_Z-BRACE_SIZE_Z]) {
        // Main spire
        translate([-BRACE_SIZE_X/2, 0, 0])
          cube([BRACE_SIZE_X, BRACE_SIZE_Y, BRACE_SIZE_Z+BRACE_TWEAK_Z]);
        
        // Inner brace
        translate([-BRACE_SIZE_X/2, -RACK_SIZE_Y/2, 0])
          cube([BRACE_SIZE_X, RACK_SIZE_Y/2, 2*WORM_HEIGHT]);
        
        // Top bevel
        translate([0,0,2*WORM_HEIGHT])
        scale([BRACE_SIZE_X, RACK_SIZE_Y/2, RACK_SIZE_Y/2])
        translate([-0.5,-1,0])
        difference() {
          cube(1);
          rotate([45,0,0])
            cube(3);
        }
        
        // Outer brace bevel
        scale([BRACE_SIZE_X, BRACE_SIZE_Y, BRACE_SIZE_Y])
        translate([-0.5,1,0])
        mirror([0,1,0])
        mirror([0,0,1])
        difference() {
          cube(1);
          rotate([45,0,0])
            cube(3);
        }
      }
    }
    translate([0,BLOCK_SIZE_Y/2,0])
      cube([RACK_SIZE_X+SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
    cylinder(d=SYRINGE_DIAM+SLOP, h=FOREVER, center=true);
    { // Worm cutout
      translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET, BLOCK_SIZE_Z + PLATE_SIZE_Z - 5])
        cylinder(d=WORM_DIAM+GEAR_OFFSET+SLOP, h=WORM_HEIGHT+SLOP);
      translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET, BLOCK_SIZE_Z + PLATE_SIZE_Z - 5 + WORM_HEIGHT + SLOP])
        cylinder(d1=WORM_DIAM+GEAR_OFFSET+SLOP, d2=0, h=WORM_DIAM);
    }
  }
}
*/
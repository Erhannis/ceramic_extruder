use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/quickfitPlate/blank_plate.scad>

$fn=60;

//nema17_mount_holes(depth=10, l=0, slop=0, $fn=60);
//translate([50,50,0])
//nema17_stepper($fn=60);
//flattedShaft(h=40,r=5,$fn=60);

function sqr(x) = x * x;

module nema17_housing(motor_height = 39.3, side_thickness = 10, top_thickness = 3.5, slop = 0, joiner_clearance = 0, top = false) {
  NEMA = 17;
  WIDTH = nema_motor_width(NEMA);
  THICK = side_thickness;
  difference() {
    cube([2*THICK+WIDTH + 2*slop, 2*THICK+WIDTH + 2*slop, 2*top_thickness+motor_height + 2*slop], center=true);
    echo(WIDTH-2*THICK);
    cube([FOREVER, WIDTH-2*THICK, motor_height+2*slop], center=true);
    cube([WIDTH-2*THICK, FOREVER, motor_height+2*slop], center=true);
    if (false) {
      cube([WIDTH-2*THICK+2*slop, WIDTH-2*THICK+2*slop, FOREVER], center=true);
    } else {
      cylinder(d=nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, h=FOREVER, center=true);
    }
    cube([WIDTH+2*slop, WIDTH+2*slop, motor_height+2*slop], center=true);
    
    mirror([top?1:0,0,0])
    for (i = [0:3]) {
      rotate([0,0,i*90])
        translate([WIDTH/2 + THICK/2  + slop,-WIDTH/2 - slop,0])
          translate([0,0,-THICK/2])
            cube([THICK, 2*THICK, THICK], center=true);
    }
    
    translate([-FOREVER/2, -FOREVER/2, 0])
      cube(FOREVER);
    cube(FOREVER);
  }

  mirror([top?1:0,0,0])
  for (i = [0:3]) {
    rotate([0,0,i*90])
      translate([WIDTH/2 + THICK/2 + slop,-WIDTH/2 - slop,0])
        rotate([90,0,0])
          if (top)
            half_joiner2(h=THICK*2, w=THICK);
          else
            half_joiner(h=THICK*2, w=THICK);
  }
}

//nema17_housing(slop=1, top=false);

module undercut(size=[1,1,1], center=false) {
  translate([center ? -size[0]/2 : 0, center ? -size[1]/2 : 0, center ? -size[2]/2 : 0]) {
    cube(size);
    translate([0,0,size[2]])
    scale([size[0],size[1],size[0]])
    difference() {
      cube(1);
      rotate([0,-45,0])
        cube(3);
    }
  }
}

//undercut([5, 10, 7], center=true);

/*
translate([40,0,0])
difference() {
  gear(mm_per_tooth=4.2,number_of_teeth=10,clearance=0.1,thickness=5);
  flattedShaft(h=40,r=2.5,center=true);
}
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
WORM_DIAM = 52;
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

/*
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
*/



PLATE_SIZE_X = 28;
PLATE_SIZE_Y = 100;
PLATE_SIZE_Z = 5;
PLATE_OFFSET = 20;

BLOCK_SIZE_X = PLATE_SIZE_X;
BLOCK_SIZE_Y = 35;
BLOCK_SIZE_Z = 52;

BRACE_SIZE_X = BLOCK_SIZE_X;
BRACE_SIZE_Y = RACK_SIZE_Y;
BRACE_SIZE_Z = RACK_SIZE_Z + 10;
BRACE_Y_COVER = 0;//2.5;
BRACE_TWEAK_Z = -35;

WORM_CUTOUT_Z_OFFSET = -8.7 + PLATE_SIZE_Z+7;

SLOP = 1;
MOTOR_HOUSING_SLOP = 0;

MOTOR_SIZE_Z = 39.3;


{ // Main block
  difference() {
    union() {
      translate([0,0,BLOCK_SIZE_Z/2 + PLATE_SIZE_Z])
        cube([BLOCK_SIZE_X, BLOCK_SIZE_Y, BLOCK_SIZE_Z], center=true);
      translate([-PLATE_SIZE_X/2, PLATE_OFFSET-PLATE_SIZE_Y/2, 0])
        plate();
      translate([0,BLOCK_SIZE_Y/2,BLOCK_SIZE_Z+PLATE_SIZE_Z+RACK_SIZE_Z-BRACE_SIZE_Z]) {
        // Main spire
        translate([-BRACE_SIZE_X/2, 0, 0])
          cube([BRACE_SIZE_X, BRACE_SIZE_Y, BRACE_SIZE_Z+BRACE_TWEAK_Z]);
                
        // Inner brace
        translate([-BRACE_SIZE_X/2, -BRACE_Y_COVER-RACK_SIZE_Y/2, 0])
          cube([BRACE_SIZE_X, BRACE_Y_COVER + RACK_SIZE_Y/2, 2*WORM_HEIGHT - BRACE_Y_COVER]);
        
        // Top bevel
        translate([0,0,2*WORM_HEIGHT - BRACE_Y_COVER])
        scale([BRACE_SIZE_X, BRACE_Y_COVER+RACK_SIZE_Y/2, BRACE_Y_COVER+RACK_SIZE_Y/2])
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
      { // New spire base
        translate([0,BLOCK_SIZE_Y/2,0])
        translate([-BRACE_SIZE_X/2, 0, 0])
        cube([BRACE_SIZE_X, BRACE_SIZE_Y, BRACE_SIZE_Z+BRACE_TWEAK_Z]);
      }
      difference() {
        // Yes, I know this is a mess
        translate([0,0,-5.5 - MOTOR_SIZE_Z/2]) {
          translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_CUTOUT_Z_OFFSET]) {
            difference() {
              union() {
                nema17_housing(slop=MOTOR_HOUSING_SLOP, top=false, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
                // Base
                BASE_SIZE_Z = BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_CUTOUT_Z_OFFSET -5.5 - MOTOR_SIZE_Z/2 -(2*MOTOR_HOUSING_TOP_THICKNESS+MOTOR_SIZE_Z + 2*MOTOR_HOUSING_SLOP)/2;
                translate([0,0,BASE_SIZE_Z/2 -(-5.5 - MOTOR_SIZE_Z/2) -(BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_CUTOUT_Z_OFFSET)])
                  cube([2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(17) + 2*MOTOR_HOUSING_SLOP, 2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(17) + 2*MOTOR_HOUSING_SLOP, BASE_SIZE_Z], center=true);
              }
              translate([0,10,0])
                translate([0,FOREVER/2,0])
                  cube([nema_motor_width(17)+2*MOTOR_HOUSING_SLOP, FOREVER, FOREVER], center=true);
            }
          }
        }
        {// Cutouts
          CUTOUT_SIZE_X = 10;
          translate([-CUTOUT_SIZE_X - PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
            undercut([CUTOUT_SIZE_X, FOREVER, 10.5]);
          translate([CUTOUT_SIZE_X + PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
            translate([0,FOREVER,0])
            rotate([0,0,180])
            undercut([CUTOUT_SIZE_X, FOREVER, 10.5]);
          for (i = [0,1])
            mirror([i,0,0])
              translate([CUTOUT_SIZE_X + PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
                translate([0,-8,0])
                  rotate([0,0,90])
                    undercut([10, CUTOUT_SIZE_X, 1]);
        }
      }
    }
    translate([0,BLOCK_SIZE_Y/2,0])
      cube([RACK_SIZE_X+SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
    cylinder(d=SYRINGE_DIAM+SLOP, h=FOREVER, center=true);
    { // Worm cutout
      translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_CUTOUT_Z_OFFSET])
        cylinder(d=WORM_DIAM+GEAR_OFFSET+SLOP, h=WORM_HEIGHT+SLOP);
      translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_CUTOUT_Z_OFFSET + WORM_HEIGHT + SLOP])
        cylinder(d1=WORM_DIAM+GEAR_OFFSET+SLOP, d2=0, h=WORM_DIAM);
    }
  }
}


MOTOR_HOUSING_SIDE_THICKNESS = 10;
MOTOR_HOUSING_TOP_THICKNESS = 3.5;
/*
translate([70,0,MOTOR_SIZE_Z/2+MOTOR_HOUSING_SLOP+MOTOR_HOUSING_TOP_THICKNESS])
difference() { // Motor housing top
  nema17_housing(slop=MOTOR_HOUSING_SLOP, top=true, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
  translate([0, -(nema_motor_width(17)+MOTOR_HOUSING_SIDE_THICKNESS)/2-SLOP, 0])
    cube([PLATE_SIZE_X+2*SLOP, MOTOR_HOUSING_SIDE_THICKNESS+2*SLOP, FOREVER], center=true);
}
*/
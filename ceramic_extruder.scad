/**
A paste extruder, intended specifically for ceramic.
Render each of the starred-out root-level blocks near the bottom
(from the plunger to the motor housing top) one by one, saving them
to files.  Print them.  Note the instructions on each.
Also, print a gearbox from https://github.com/Erhannis/gearbox - but
you can skip the sheaths.
*/

use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/getriebe/Getriebe.scad>
use <deps.link/gearbox/gearbox.scad>

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

module nema17_housing_weird(motor_height = 39.3, side_thickness = 10, top_thickness = 3.5, slop = 0, joiner_clearance = 0, holes = true, top = false) {
  NEMA = 17;
  WIDTH = nema_motor_width(NEMA);
  THICK = side_thickness;
  difference() {
    cube([2*THICK+WIDTH + 2*slop, 2*THICK+WIDTH + 2*slop, 2*top_thickness+motor_height + 2*slop], center=true);
    echo(WIDTH-2*THICK);
    if (top) {
      cube([FOREVER, WIDTH-2*THICK, motor_height+2*slop], center=true);
      cube([WIDTH-2*THICK, FOREVER, motor_height+2*slop], center=true);
    } else {
      translate([-FOREVER/2,0,0]) cube([FOREVER, WIDTH+2*slop, motor_height+2*slop], center=true);
    }
    HOLE = 1;
    if (HOLE == 0) {
      cube([WIDTH-2*THICK+2*slop, WIDTH-2*THICK+2*slop, FOREVER], center=true);
    } else if (HOLE == 1) {
      rotate([0,0,45]) cube([nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, FOREVER], center=true);
    } else if (HOLE == 2) {
      cylinder(d=nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, h=FOREVER, center=true);
    } else if (HOLE == 3) {
      union() {
        cylinder(d=nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, h=FOREVER, center=true);
        intersection() {
          rotate([0,0,45]) cube([nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, FOREVER], center=true);
          cube([FOREVER, (nema_motor_plinth_diam(NEMA)+2*slop+THICK/2) / sqrt(2), FOREVER], center=true);
        }
      }
    }
    cube([WIDTH+2*slop, WIDTH+2*slop, motor_height+2*slop], center=true);
    
    for (j = [0,1]) {
      mirror([j?1:0,0,0])
      for (i = [1,3]) {
        rotate([0,0,i*90])
          translate([WIDTH/2 + THICK/2  + slop,-WIDTH/2 - slop,0])
            translate([0,0,-THICK/2])
              cube([THICK, 2*THICK, THICK], center=true);
      }
    }
    
    translate([-FOREVER/2, -FOREVER/2, 0])
      cube(FOREVER);
    cube(FOREVER);
  }

  for (j = [0,1]) {
    mirror([j?1:0,0,0])
    for (i = [1,3]) {
      rotate([0,0,i*90])
        translate([WIDTH/2 + THICK/2 + slop,-WIDTH/2 - slop,0])
          rotate([90,0,0])
            if (top)
              half_joiner2(h=THICK*2, w=THICK);
            else
              half_joiner(h=THICK*2, w=THICK);
    }
  }
}

module nema17_housing_on_side(motor_height = 39.3, side_thickness = 10, top_thickness = 3.5, slop = 0, joiner_clearance = 0, port_width=18, top = false) {
  //TODO Fix
  NEMA = 17;
  WIDTH = nema_motor_width(NEMA);
  THICK = side_thickness;
  DIFF = (WIDTH-motor_height)/2;
  difference() {
    cube([2*THICK+motor_height + 2*slop, 2*THICK+WIDTH + 2*slop, 2*top_thickness+WIDTH + 2*slop], center=true);
    echo(WIDTH-2*THICK);
    cube([FOREVER, WIDTH-2*THICK, WIDTH+2*slop], center=true);
    cube([motor_height-2*THICK, FOREVER, WIDTH+2*slop], center=true);
    if (false) {
      cube([motor_height-2*THICK+2*slop, WIDTH-2*THICK+2*slop, FOREVER], center=true);
    } else {
      //TODO Alter for side
      cylinder(d=nema_motor_plinth_diam(NEMA)+2*slop+THICK/2, h=FOREVER, center=true);
    }
    cube([motor_height+2*slop, WIDTH+2*slop, WIDTH+2*slop], center=true);
    
    mirror([top?1:0,0,0])
    for (i = [0,2]) {
      rotate([0,0,i*90])
        translate([motor_height/2 + THICK/2 + slop,-WIDTH/2 - slop,0])
          translate([0,0,-THICK/2])
            cube([THICK, 2*THICK, THICK], center=true);
    }
    mirror([top?1:0,0,0])
    for (i = [1,3]) {
      rotate([0,0,i*90])
        translate([motor_height/2 + THICK/2 + slop+DIFF,-WIDTH/2 - slop+DIFF,0])
          translate([0,0,-THICK/2])
            cube([THICK, 2*THICK, THICK], center=true);
    }
    
    if (top) {
      translate([(motor_height-2*THICK+2*slop)-(2*THICK+motor_height + 2*slop)/2,0,0])
        cube([motor_height-2*THICK+2*slop, port_width, FOREVER], center=true);
    }
    
    translate([-FOREVER/2, -FOREVER/2, 0])
      cube(FOREVER);
    cube(FOREVER);
  }

  mirror([top?1:0,0,0])
  for (i = [0,2]) {
    rotate([0,0,i*90])
      translate([motor_height/2 + THICK/2 + slop,-WIDTH/2 - slop,0])
        rotate([90,0,0])
          if (top)
            half_joiner2(h=THICK*2, w=THICK);
          else
            half_joiner(h=THICK*2, w=THICK);
  }
  mirror([top?1:0,0,0])
  for (i = [1,3]) {
    rotate([0,0,i*90])
      translate([motor_height/2 + THICK/2 + slop+DIFF,-WIDTH/2 - slop+DIFF,0])
        rotate([90,0,0])
          if (top)
            half_joiner2(h=THICK*2, w=THICK);
          else
            half_joiner(h=THICK*2, w=THICK);
  }
}

//nema17_housing_on_side(slop=MOTOR_HOUSING_SLOP, top=true, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
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


{
  FOREVER = 1000;
  SYRINGE_HOLE_DIAM = 18;
  SYRINGE_DIAM = 16.5;
  SYRINGE_LENGTH = 76;
}


GEAR_OFFSET = 1;

RACK_SIZE_X = 7;
RACK_SIZE_Y = 7 + GEAR_OFFSET;
RACK_OVERHANG_SIZE_X = RACK_SIZE_X;
RACK_OVERHANG_STICKOUT_SIZE_Y = 39-9.5+0.9;
RACK_OVERHANG_SIZE_Y = 20;
RACK_OVERHANG_LEDGE_Z = RACK_OVERHANG_SIZE_X;
RACK_OVERHANG_SIZE_Z = RACK_OVERHANG_SIZE_Y + RACK_OVERHANG_LEDGE_Z;
RACK_SIZE_Z = SYRINGE_LENGTH + RACK_OVERHANG_SIZE_Z + 15;

RACK_OFFSET_Y = 2;

GEAR_SCALE = 5/4;
GEAR_SZ = 5;
GEAR_SZ_GAP = 2;
GEAR_RING_D = 44;

WORM_DIAM = pfeilrad_dims(modul=2, zahnzahl=33, breite=GEAR_SZ*GEAR_SCALE, bohrung=0, eingriffswinkel=20, schraegungswinkel=30, optimiert=false)[0];
WORM_HEIGHT = RACK_SIZE_X;
MM_PER_REV = 2.08;

JOINER_DEPTH = 5;
JOINER_HEIGHT = 15;
GEAR_SHEATH_W = 6.23;
GEAR_SHEATH_D = (GEAR_RING_D+GEAR_SHEATH_W)*GEAR_SCALE;
GEAR_SHEATH_H = GEAR_SZ*GEAR_SCALE;

PLATE_SIZE_X = 28;
PLATE_SIZE_Y = 100;
PLATE_SIZE_Z = 5;
PLATE_OFFSET = 24;

BLOCK_SIZE_X = PLATE_SIZE_X;
BLOCK_SIZE_Y = 35;
BLOCK_SIZE_Z = 52;

BRACE_SIZE_X = BLOCK_SIZE_X;
BRACE_SIZE_Y = RACK_SIZE_Y;
BRACE_SIZE_Z = RACK_SIZE_Z + 10;
BRACE_Y_COVER = 0;//2.5;
BRACE_TWEAK_Z = -35;

WORM_OZ = PLATE_SIZE_Z;
WORM_SLOP = 0.8;
WORM_CUTOUT_SLOP = 5;

WORM_PZ = BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_OZ;
WORM_PY = GEAR_SHEATH_D/2+BLOCK_SIZE_Y/2+BRACE_SIZE_Y;
//translate([0,WORM_PY,WORM_PZ]) cube(center=true);

SLOP = 1;
MOTOR_HOUSING_SLOP = 0.1;

MOTOR_SIZE_Z = 39.3;

* rotate([0,-90,0])
{ // Plunger
  union() {
    if (true) {
      // Mildly obnoxious math to make the rack the right size
      HOEHE0 = RACK_SIZE_Y;
      HOEHE = RACK_SIZE_Y - (zahnstange_dims(modul=2, laenge=RACK_SIZE_Z, hoehe=HOEHE0, breite=RACK_SIZE_X/2, eingriffswinkel = 20, schraegungswinkel = 30)[3] - HOEHE0);
      
      rotate([0,90,0]) translate([0,0,RACK_SIZE_X/2]) rotate([0,180,0]) {
    zahnstange(modul=2, laenge=RACK_SIZE_Z, hoehe=HOEHE, breite=RACK_SIZE_X/2, eingriffswinkel = 20, schraegungswinkel = 30);
    mirror([0,0,1]) zahnstange(modul=2, laenge=RACK_SIZE_Z, hoehe=HOEHE, breite=RACK_SIZE_X/2, eingriffswinkel = 20, schraegungswinkel = 30);
      }
    } else {
      cube([RACK_SIZE_X, RACK_SIZE_Y, RACK_SIZE_Z]);
    }
    translate([0,-RACK_OVERHANG_SIZE_Y,RACK_SIZE_Z-RACK_OVERHANG_SIZE_Z]) {
      translate([0,RACK_OVERHANG_SIZE_Y-RACK_OVERHANG_STICKOUT_SIZE_Y,0])
        cube([RACK_OVERHANG_SIZE_X, RACK_OVERHANG_STICKOUT_SIZE_Y, RACK_OVERHANG_LEDGE_Z]);
      difference() {
        cube([RACK_OVERHANG_SIZE_X, RACK_OVERHANG_SIZE_Y, RACK_OVERHANG_SIZE_Z]);
        translate([0,0,RACK_OVERHANG_LEDGE_Z])
        rotate([45,0,0])
          cube(FOREVER);
      }
    }
  }
}

union() { // Main block
  difference() {
    union() {
      translate([0,0,BLOCK_SIZE_Z/2 + PLATE_SIZE_Z]) // Body block
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
      { // Cross-support spire
        translate([0,-BLOCK_SIZE_Y/2,BLOCK_SIZE_Z+PLATE_SIZE_Z+RACK_SIZE_Z-BRACE_SIZE_Z])
        difference() {
          translate([-BRACE_SIZE_X/2, 0, 0])
            cube([BRACE_SIZE_X, BRACE_SIZE_Y, BRACE_SIZE_Z+BRACE_TWEAK_Z-RACK_OVERHANG_SIZE_Y]);

          translate([0,-0.5-RACK_OVERHANG_STICKOUT_SIZE_Y,0])
          translate([0,RACK_OFFSET_Y+BLOCK_SIZE_Y/2-(-BLOCK_SIZE_Y/2),0]) // Rack hole
            cube([RACK_SIZE_X+SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
        }
      }
      difference() { // Motor housing
        motor_height = 39.3;
        NEMA = 17;
        HOUSE_WIDTH = 2*MOTOR_HOUSING_TOP_THICKNESS+motor_height + 2*MOTOR_HOUSING_SLOP;
        HOUSE_HEIGHT = 2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(NEMA) + 2*MOTOR_HOUSING_SLOP;
        union() {
          translate([GEAR_SCALE*(GEAR_SZ+GEAR_SZ_GAP),0,0])
          translate([HOUSE_WIDTH/2,WORM_PY,WORM_PZ])
          union() {
            rotate([0,90,0]) nema17_housing_weird(slop=MOTOR_HOUSING_SLOP, top=false, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
            BASE_HEIGHT = WORM_PZ - HOUSE_HEIGHT/2;
            translate([-HOUSE_WIDTH/4,0,-HOUSE_HEIGHT/2-BASE_HEIGHT/2])
            translate([0,0,BASE_HEIGHT/2])
            multmatrix([
              [ 1, 0, 1, 0 ],
              [ 0, 1, 0, 0 ],
              [ 0, 0, 1, 0 ],
              [ 0, 0, 0, 1 ]
            ]) {
              translate([0,0,-BASE_HEIGHT/2])
              cube([HOUSE_WIDTH/2,HOUSE_HEIGHT,BASE_HEIGHT],center=true);
            }
          }
        }
        {
          translate([-PLATE_SIZE_X/2,0,0]) OXm();
        }
        union(){ // Plate attachment cutouts
          CUTOUT_SIZE_X = FOREVER;
          * translate([-CUTOUT_SIZE_X - PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
            undercut([CUTOUT_SIZE_X, FOREVER, 10.5]);
          * translate([CUTOUT_SIZE_X + PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
            translate([0,FOREVER,0])
            rotate([0,0,180])
            undercut([CUTOUT_SIZE_X, FOREVER, 10.5]);
          * for (i = [0,1])
            mirror([i,0,0])
              translate([CUTOUT_SIZE_X + PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
                translate([0,-8,0])
                  rotate([0,0,90])
                    undercut([40, CUTOUT_SIZE_X, 1]);
          translate([CUTOUT_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
            translate([0,-8,0])
              rotate([0,0,90])
                undercut([40, CUTOUT_SIZE_X, 1]);
        }
      }
    }
    translate([0,RACK_OFFSET_Y+BLOCK_SIZE_Y/2,0]) // Rack hole
      cube([RACK_SIZE_X+SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
    translate([0,RACK_OFFSET_Y+BLOCK_SIZE_Y/2-RACK_SIZE_Y,FOREVER/2+BLOCK_SIZE_Z+PLATE_SIZE_Z]) // Remove wall covering rack, nearest syringe
      cube([RACK_SIZE_X+SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
    cylinder(d=SYRINGE_DIAM+SLOP, h=FOREVER, center=true);
    union() { // Gear cutout
      translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_OZ])
        rotate([0,90,0]) {
          cylinder(d=WORM_DIAM+GEAR_OFFSET+SLOP+WORM_CUTOUT_SLOP, h=WORM_HEIGHT+SLOP,center=true);
          difference() {
            union() {
              d0 = WORM_DIAM+GEAR_OFFSET+SLOP+WORM_CUTOUT_SLOP;
              h0 = WORM_HEIGHT+SLOP;
              for (i = [0,1])
                mirror([0,0,i])
                cylinder(d1=d0+h0,d2=d0, h=h0/2);
            }
            rotate([0,0,45]) OXp();
          }
        }
    }
    union() { // Gear sheath attachment points
      translate([-GEAR_SCALE*(GEAR_SZ+GEAR_SZ_GAP),BLOCK_SIZE_Y/2+BRACE_SIZE_Y,WORM_PZ])
      translate([-GEAR_SHEATH_H/2,-JOINER_DEPTH,-JOINER_HEIGHT/2])
      for (i=[-1,1]) {
        translate([0,0,i*(GEAR_SHEATH_D/2-JOINER_HEIGHT/2)]) pinJoinerCutout(depth=JOINER_DEPTH,height=JOINER_HEIGHT,width=GEAR_SHEATH_H,width_slop=0.6);
      }
    }
  }
}

* union() { // Gearbox gear sheath
  // (also print out the gearbox at https://github.com/Erhannis/gearbox , or https://www.thingiverse.com/thing:3997024 , or just use the linked dependency;
  //   and when you print it out, make the largeRing big, the smallSun big (and drive), and the big side of the shafts big,
  //   so that one side of the finished gearbox is multiple gears wide, to help keep things straight and not bind.)
  // You should probably print it at between -0.08 and -0.1 horizontal expansion
  // Excerpted from gearbox.scad
  difference() {
    pfeilrad(modul=2, zahnzahl=35, breite=GEAR_SZ*GEAR_SCALE, bohrung=0, eingriffswinkel=20, schraegungswinkel=30, optimiert=false);
    scale(GEAR_SCALE) union() {
      cylinder(d=GEAR_RING_D,h=GEAR_SZ);
      grooves();
    }
  }
}

* union() { // Gearbox attachment sheath
  // You should probably print it at between -0.08 and -0.1 horizontal expansion.
  //   Also around -0.3 initial layer horizontal expansion, unless you're
  //   confident your first layer won't get smooshed out - it blocks the pins.
  // Excerpted from gearbox.scad
  difference() {
    union() {
      h0 = GEAR_SHEATH_H;
      d0 = GEAR_SHEATH_D;
      cylinder(d=d0,h=h0*4);
      translate([0,-d0/4,h0/2]) cube([d0,d0/2,h0], center=true);
      translate([0,0,h0])
        rotate([0,180,0])
        for (i=[-1,1]) {
          translate([JOINER_HEIGHT/2+i*(d0/2-JOINER_HEIGHT/2),-d0/2-JOINER_DEPTH,0]) rotate([0,-90,0]) pinJoiner(depth=JOINER_DEPTH,height=JOINER_HEIGHT,width=h0,width_slop=0,pin_height_slop=0.5);
        }
    }
    scale(GEAR_SCALE) union() {
      cylinder(d=GEAR_RING_D,h=GEAR_SZ*4);
      grooves(big=true);
    }
  }
}

* union() { // Joiner pins
  // Note that these aren't level with 0Z, because of the way the slop is applied
  //   So you should render them into separate STL files so you don't have problems with
  //   parts of your print floating and messing up your print.
  // Note also that I've roughly chopped off the end of these so they don't stick
  //   out into the plunger shaft.  It probably won't properly reflect parameter changes.
  difference() {
    translate([-11.5,0,0]) {
      rotate([-90,0,0]) pinJoinerPin(depth=JOINER_DEPTH, height=JOINER_HEIGHT);
      translate([0,5,0]) rotate([-90,0,0]) pinJoinerPin(depth=JOINER_DEPTH, height=JOINER_HEIGHT);
    }
    OXp();
  }
}

MOTOR_HOUSING_SIDE_THICKNESS = 10;
MOTOR_HOUSING_TOP_THICKNESS = 3.5;

* union() { // Motor housing top
  difference() {
    NEMA = 17;
    W0 = 2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(NEMA) + 2*MOTOR_HOUSING_SLOP;
    translate([-W0/2+MOTOR_HOUSING_SIDE_THICKNESS/2,W0/2-MOTOR_HOUSING_SIDE_THICKNESS/2,MOTOR_SIZE_Z/2+MOTOR_HOUSING_SLOP+MOTOR_HOUSING_TOP_THICKNESS])
      nema17_housing_weird(slop=MOTOR_HOUSING_SLOP, top=true, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
    if (true) { // If you want this to fit the Snappy Quickfit Platform
      rotate([0,0,-45]) translate([0,0,0]) OXp();
    }
  }
}

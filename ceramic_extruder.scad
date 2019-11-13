// Ok, I have 25mm extra room I can use without reprinting part of my printer's structure
// Looks like 54mm is reasonable for a small gear's circumference; ~17mm diam
// Soo...seems like a 1:12 gear ratio may be acceptable??  Not sure
// Motor is 39.5 tall, 42 wide


use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/moreGears/Getriebe.scad>

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

module nema17_housing_on_side(motor_height = 39.3, side_thickness = 10, top_thickness = 3.5, slop = 0, joiner_clearance = 0, top = false) {
  //TODO Fix
  NEMA = 17;
  WIDTH = nema_motor_width(NEMA);
  THICK = side_thickness;
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
    for (i = [0:3]) {
      rotate([0,0,i*90])
        translate([motor_height/2 + THICK/2  + slop,-WIDTH/2 - slop,0])
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
      translate([motor_height/2 + THICK/2 + slop,-WIDTH/2 - slop,0])
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
  flattedShaft(h=40,r=2.5 + 0.15,center=true);
}
*/

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
RACK_OVERHANG_STICKOUT_SIZE_Y = 39-9.5;
RACK_OVERHANG_SIZE_Y = 20;
RACK_OVERHANG_LEDGE_Z = RACK_OVERHANG_SIZE_X;
RACK_OVERHANG_SIZE_Z = RACK_OVERHANG_SIZE_Y + RACK_OVERHANG_LEDGE_Z;
RACK_SIZE_Z = SYRINGE_LENGTH + RACK_OVERHANG_SIZE_Z + 15;

RACK_OFFSET_Y = 2;

WORM_DIAM = 52;
WORM_HEIGHT = RACK_SIZE_X;
MM_PER_REV = 2.08;

* rotate([0,-90,0])
{ // Plunger
  union() {
    if (false) {
      worm_rack(xs = RACK_SIZE_X, ys = RACK_SIZE_Y - GEAR_OFFSET, z = RACK_SIZE_Z, worm_diam = WORM_DIAM, o = GEAR_OFFSET, mmPerRev = MM_PER_REV);
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

WORM_OZ = PLATE_SIZE_Z+22;
WORM_SLOP = 0.8;

SLOP = 1;
MOTOR_HOUSING_SLOP = 0;

MOTOR_SIZE_Z = 39.3;

function test(modul, zahnzahl_rad, zahnzahl_ritzel, achsenwinkel=90, zahnbreite, bohrung, eingriffswinkel = 20, schraegungswinkel=0) = let (
  zahnzahl = zahnzahl_rad,
	delta_rad = atan(sin(achsenwinkel)/(zahnzahl_ritzel/zahnzahl_rad+cos(achsenwinkel))),	// Kegelwinkel des Rads
  teilkegelwinkel = delta_rad,
  
	// Dimensions-Berechnungen
	d_aussen = modul * zahnzahl,									// Teilkegeldurchmesser auf der Kegelgrundfläche,
																	// entspricht der Sehne im Kugelschnitt
	r_aussen = d_aussen / 2,										// Teilkegelradius auf der Kegelgrundfläche 
	rg_aussen = r_aussen/sin(teilkegelwinkel),						// Großkegelradius für Zahn-Außenseite, entspricht der Länge der Kegelflanke;
	c = modul / 6,													// Kopfspiel
	df_aussen = d_aussen - (modul +c) * 2 * cos(teilkegelwinkel),
	rf_aussen = df_aussen / 2,
	delta_f = asin(rf_aussen/rg_aussen),
	rkf = rg_aussen*sin(delta_f),									// Radius des Kegelfußes
	// Größen für Komplementär-Kegelstumpf
	hoehe_k = (rg_aussen-zahnbreite)/cos(teilkegelwinkel),			// Höhe des Komplementärkegels für richtige Zahnlänge
	rk = (rg_aussen-zahnbreite)/sin(teilkegelwinkel),				// Fußradius des Komplementärkegels
	rfk = rk*hoehe_k*tan(delta_f)/(rk+hoehe_k*tan(delta_f)),		// Kopfradius des Zylinders für 
																	// Komplementär-Kegelstumpf
  
  
  outer = rkf*1.001,
  inner = (rfk/rkf) * rkf*1.001
  ) outer;


  GEAR_SIZE_MULTIPLIER = 1;


difference() {
  union() {
    outer_r = test(modul=1*GEAR_SIZE_MULTIPLIER, zahnzahl_rad=50, zahnzahl_ritzel=11, achsenwinkel=90, zahnbreite=5*GEAR_SIZE_MULTIPLIER, bohrung=3, eingriffswinkel = 20, schraegungswinkel=30);
    translate([0,0,-5]) cylinder(r=outer_r,h=5);
    pfeilkegelradpaar(modul=1*GEAR_SIZE_MULTIPLIER, zahnzahl_rad=50, zahnzahl_ritzel=11, achsenwinkel=90, zahnbreite=5*GEAR_SIZE_MULTIPLIER, bohrung_rad=3, bohrung_ritzel=3, eingriffswinkel = 20, schraegungswinkel=30, zusammen_gebaut=false);
  }
  translate([35,0,0])
    flattedShaft(h=40,r=2.5 + 0.15,center=true);
  flattedShaft(h=40,r=2.5 + 0.15,center=true);
}

* union() { // Main block
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
            cube([RACK_SIZE_X+4*SLOP, RACK_SIZE_Y+SLOP, FOREVER], center=true);
        }
      }
      difference() { // Motor housing
        BASE_OZ = 3.3;
        // Yes, I know this is a mess
        translate([7,0,0])
        translate([0,0,-5.5 - MOTOR_SIZE_Z/2]) {
          translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + BASE_OZ]) {
            difference() {
              translate([0,WORM_SLOP,0]) {
                union() {
                  nema17_housing_on_side(slop=MOTOR_HOUSING_SLOP, top=false, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
                  // Base
                  BASE_SIZE_Z = BLOCK_SIZE_Z + PLATE_SIZE_Z + BASE_OZ -5.5 - MOTOR_SIZE_Z/2 -(2*MOTOR_HOUSING_TOP_THICKNESS+MOTOR_SIZE_Z + 2*MOTOR_HOUSING_SLOP)/2;
                  translate([0,0,BASE_SIZE_Z/2 -(-5.5 - MOTOR_SIZE_Z/2) -(BLOCK_SIZE_Z + PLATE_SIZE_Z + BASE_OZ)])
                    cube([2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(17) + 2*MOTOR_HOUSING_SLOP, 2*MOTOR_HOUSING_SIDE_THICKNESS+nema_motor_width(17) + 2*MOTOR_HOUSING_SLOP, BASE_SIZE_Z], center=true);
                }
              }
              translate([0,10,0])
                translate([0,FOREVER/2,0])
                  cube([nema_motor_width(17)+2*MOTOR_HOUSING_SLOP, FOREVER, FOREVER], center=true);
            }
          }
        }
        {// Plate attachment cutouts
          CUTOUT_SIZE_X = 12;
          * translate([-CUTOUT_SIZE_X - PLATE_SIZE_X/2, 10 + BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, 0])
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
        rotate([0,90,0])
        cylinder(d=WORM_DIAM+GEAR_OFFSET+SLOP, h=WORM_HEIGHT+SLOP,center=true);
    }
  }
}
      * union() { // Gear mock
        translate([0, BLOCK_SIZE_Y/2 + WORM_DIAM/2 + GEAR_OFFSET + (RACK_SIZE_Y - GEAR_OFFSET)/2, BLOCK_SIZE_Z + PLATE_SIZE_Z + WORM_OZ])
          rotate([0,90,0])
          cylinder(d=WORM_DIAM+GEAR_OFFSET, h=WORM_HEIGHT,center=true);
      }


MOTOR_HOUSING_SIDE_THICKNESS = 10;
MOTOR_HOUSING_TOP_THICKNESS = 3.5;

/*
translate([70,0,MOTOR_SIZE_Z/2+MOTOR_HOUSING_SLOP+MOTOR_HOUSING_TOP_THICKNESS])
difference() { // Motor housing top
  nema17_housing(slop=MOTOR_HOUSING_SLOP, top=true, side_thickness=MOTOR_HOUSING_SIDE_THICKNESS, top_thickness=MOTOR_HOUSING_TOP_THICKNESS);
  translate([0,WORM_SLOP/2 -(nema_motor_width(17)+MOTOR_HOUSING_SIDE_THICKNESS)/2-SLOP, 0])
    cube([PLATE_SIZE_X+2*SLOP,WORM_SLOP + MOTOR_HOUSING_SIDE_THICKNESS+2*SLOP, FOREVER], center=true);
}
*/
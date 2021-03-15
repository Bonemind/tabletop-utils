include <ikea_skadis.scad>;
$fn=60;

// Diameter of the bottle
bottle_diameter = 26;

// The number of bottles to hold
bottle_count = 6;

// How high each bottle is. Just used in intermediary steps
bottle_height = 80;

// How deep to make the holder, if less than bottle height, the bottles will stick out
holder_depth = 45;

// Padding between bottles
padding = 1;

// Whether to generate all pegs, or just the outmost 2
generate_all_pegs = true;

// This makes the pegs slide in slightly harder, but also harder to slide out
peg_retainer = true;

// Whether to fill in the pegs or not, can save some filament
peg_infill = true;

// Spacing between the pegs, always 40 for skadis. Just used for output message calculation
peg_spacing = 40;


peg_count = ceil((bottle_count*bottle_diameter)/peg_spacing);
computed_padding = ((peg_count*peg_spacing)-(bottle_count*bottle_diameter))/bottle_count;
total_width = ceil(bottle_count*bottle_diameter + (bottle_count-1)*computed_padding);


echo("Total width", total_width);
echo("Computed padding", computed_padding);
echo("Pegs", peg_count);

// The actual holder unit
rotate([90,0,0]) union() {

    difference() {
        cube([total_width, bottle_diameter/2, holder_depth]);
        translate([0,computed_padding,0-0.1]) Bottles(bottle_count, bottle_diameter, bottle_height+0.1, computed_padding);
        BottleCutout(bottle_count, bottle_diameter, holder_depth, computed_padding);
    }
    // Skadis pegs
    // used to be -4 for a 10 deg forwards leaning angle
    translate([total_width/2,0,-3]) rotate([-90,0,0]) skadis_pegs_position(length=total_width, all_pegs = generate_all_pegs) skadis_peg(peg_infill, peg_retainer);

    // Skadis peg attachment
    cube([total_width, bottle_diameter/2, padding*2]);

    // Back layer compensation
    translate([0,0,-3]) cube([total_width, 5, 3]);

    // Front slight edge
    translate([0,0,holder_depth-2]) cube ([total_width, 4, 2]);
}

// Generates shape of bottles, which will be used to cut out space for them
module Bottles (count, diameter, height, spacing) {
    for (i=[1:count]) {
        loc = (diameter/2) + ((i-1)*diameter) + (i-1)*spacing;
        translate([loc,diameter/2,0]) cylinder(d=diameter, h=height);
    }
}

module BottleCutout(count, diameter, depth, spacing) {
    for (i=[1:count]) {
        cutout_width = 0.5*diameter;
        loc = (diameter/2) + ((i-1)*diameter) + (i-1)*spacing - cutout_width/2;

        // Empty space to save filament
        // peg side cutout in the bottom of the model
        translate([loc,-1,padding*4]) cube([cutout_width, 30, (depth/2 - 6*padding)]);
        // far side cutout in the bottom of the model.
        translate([loc,-1,padding*2+depth/2]) cube([cutout_width, 30, (depth/2 - 4*padding)]);
    }
}
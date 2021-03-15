include <ikea_skadis.scad>;
$fn=60;

// Diameter of bottle
bottle_diameter = 36;

// Number of bottles in base "level"
bottle_count = 3;

// Thickness around bottle
wall_thickness = 2;

// Bottle holder height, how deep the bottle will slide into the holder
lip_height = 3;

// Number of levels, layers of bottle holders in front of each other
levels = 2;

// How wide to make the support bars at the bottom of the bottle holders
support_bar_width = 4;

// Whether this is a right end part, so whether the tiling ends here
right_end = true;

// Whether to generate all pegs, or just the outmost 2
generate_all_pegs = true;

// This makes the pegs slide in slightly harder, but also harder to slide out
peg_retainer = true;

// Whether to fill in the pegs or not, can save some filament
peg_infill = true;

// Spacing between the pegs, always 40 for skadis. Just used for output message calculation
peg_spacing = 40;


effective_diameter = bottle_diameter + wall_thickness + wall_thickness;
total_width = ceil(effective_diameter*bottle_count);
peg_count = ceil(total_width/peg_spacing);


echo("Total width", total_width);
echo("Pegs", peg_count);

// The total "unit". Including skadis pegs.
union() {
    difference() {
        translate([0,0.5*effective_diameter,0]) BottleHolders(bottle_diameter, wall_thickness, lip_height, levels, bottle_count, right_end);
        // For tiling, essentially cut out the next segment
        if (!right_end) {
            translate([total_width-((bottle_count+1)*0.5),0.5*effective_diameter,0]) BottleHolders(bottle_diameter, wall_thickness, lip_height, levels, 1, false);
        }
    }

    cube([total_width - effective_diameter, wall_thickness, wall_thickness+lip_height]);
    translate([0, -3, 0]) cube([total_width - effective_diameter, 3, 3]);
    translate([total_width/2 - 0.5*effective_diameter,-3,0]) rotate([0,0,180]) skadis_pegs_position(length=total_width, all_pegs = generate_all_pegs) skadis_peg(peg_infill, peg_retainer);
}


// Bottle holder "unit"
module BottleHolders(diameter, wall_thickness, lip_height, levels, bottle_count, generate_right_end) {
    effective_diameter = diameter + wall_thickness + wall_thickness;
    for (lvl=[0:levels-1]) {
        effective_bottle_count = bottle_count - (generate_right_end ? lvl : 0);
        for (i=[0:effective_bottle_count-1]) {
            // Slightly decrease spacing every iteration to make sure the containers connect
            xpos = (effective_diameter)*i+(lvl * 0.5 * effective_diameter) - (i*0.5);
            translate([xpos, effective_diameter * lvl * 0.85,0]) BottleContainer(bottle_diameter, wall_thickness, lip_height);
        }
    }
}

// Container for a single bottle
module BottleContainer(diameter, wall_thickness, lip_height) {
    inner_hole_difference = 5;
    union() {
        difference() {
            cylinder(d=diameter+wall_thickness+wall_thickness, h=wall_thickness+lip_height);
            translate([0,0,wall_thickness]) cylinder(d=diameter, h=wall_thickness+lip_height);
            translate([0,0,-wall_thickness]) cylinder(d=diameter-inner_hole_difference, h=wall_thickness+lip_height);
        }
        translate([-0.5*(diameter+wall_thickness)+1, -0.5*support_bar_width,0]) cube([diameter+wall_thickness-2, support_bar_width,wall_thickness]);
        rotate([0,0,60]) translate([-0.5*(diameter+wall_thickness)+1, -0.5*support_bar_width,0]) cube([diameter+wall_thickness-2, support_bar_width,wall_thickness]);
    }
}
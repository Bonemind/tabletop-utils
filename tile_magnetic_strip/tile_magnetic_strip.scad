
// Number of faces
$fn=60;

// Inch to mm, makes it easier to read than 19.05mm == 0.75in
inch = 25.4;



// Magnet hole diameter
magnet_diameter = 5.5;

// Tile dimensions (TT=1.25, OpenLock=1)
tile_size = 1.25*inch;

// Length of the strip in tiles
tile_count = 3;

// Strip width (TT assumes 0.25in walls)
strip_width = 0.25*inch;

// Strip Height
strip_height = 0.25*inch;

// How much space to leave at the bottom of the magnet hole
magnet_hole_bottom_offset = 1;

// Whether to hollow the strip as much as possible
hollow = true;

// x y z

difference(){
    cube([strip_width, tile_size * tile_count, strip_height]);
    for (i = [0:tile_count-1]) {
        translate([0.5*strip_width, i*tile_size + 0.5*tile_size, magnet_hole_bottom_offset]) cylinder(h=strip_height, d=magnet_diameter);
    }
    if (hollow) {
        for (i = [0:tile_count]) {
            // Translation is based on: -1mm for the translation we did compare to the base object, 0.5*tile size for where the holes are, and some spacing for the holes
            // The first and last subtraction are half size
            first_hole_offset = 0.5*tile_size + 0.5*magnet_diameter +1;
            if (i==0) {
                translate([1, i*tile_size+1, 1]) cube([strip_width-2, (tile_size*0.5)-(0.5*magnet_diameter)-2, strip_height]);
            } else if (i==tile_count) {
                translate([1, first_hole_offset + (i-1)*tile_size, 1]) cube([strip_width-2, (tile_size-magnet_diameter)*0.5-2, strip_height*2]);
            } else {
                translate([1, first_hole_offset + (i-1)*tile_size, 1]) cube([strip_width-2, tile_size-magnet_diameter-2, strip_height*2]);
            }
        }
    }

}

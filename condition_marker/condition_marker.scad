use <fontmetrics.scad>;

// todo: Make diameter of top ring smaller (now is too large, doesn't fit with bottom)
// todo: Top ring conflicts with bottom magnet
// todo: maybe wrap icon across rim?
$fn=60;
marker_height = 4;
marker_diameter = 25;

magnet_diameter = 5.5;
magnet_height = 1.5;

marker_text = "Dazed";
marker_text_char_count = 10;


// Not all fonts seem to work with the fontmetrics lib
font = "Liberation Sans";
font_size = 0.60*marker_height;
// Magic number is the number a character of consolas will take

// [[leftX,bottomY],[width,height]] 
//text_dimensions = measureTextBounds(marker_text,font=font,size=font_size,valign="bottom",halign="center");
text_dimensions = measureTextBounds(marker_text, font=font, size=font_size, valign="bottom", halign="center");

// Create the cube that backs the text, and the text itself
translate([marker_diameter*0.5 -2, -0.5*text_dimensions[1][0] - 1, 0]) cube([2, text_dimensions[1][0] + 2, marker_height]);
rotate([90,0,90]) translate([0, (marker_height - text_dimensions[1][1]) / 2, marker_diameter*0.5]) linear_extrude(0.3) text(marker_text, valign="bottom", halign="center", size = font_size);

// Create the Marker
difference() {
    cylinder(h=marker_height, d=marker_diameter);
    translate([0,0,-1]) cylinder(h=magnet_height+1, d=magnet_diameter);
    translate([0,0, -1]) innerDisk(height=marker_height, inner_diameter=magnet_diameter+1);
}

// Create the marker "topping"
translate([0,0,marker_height]) innerDisk(height=1, diameter=marker_diameter-1.5, inner_diameter=magnet_diameter);

// Module to generate a disk with a hole in the middle for magnets
module innerDisk(height=marker_height, diameter=marker_diameter-1, inner_diameter=magnet_diameter) {
    difference() {
        cylinder(h=height, d=diameter);
        translate([0,0,-0.5]) cylinder(h=marker_height+1, d=inner_diameter);
    }
}

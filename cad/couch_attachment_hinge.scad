//include <MCAD/boxes.scad>

width = 28;
height = 7;
nut_depth = 3.5;
nut_width = 9.5;
rod_r = 2.6;
hinge_pin_r = 1.75;

difference() {
        translate([0, 0, height/2]) rotate([90, 90, 0]) cube([height, width, 30], true);
        // hinge cutout
        translate([-width/2, 0, height/2]) cube([width*.7, 20, height * 2], true);
        // hinge pin
        translate([-width/3, 0, height/2]) rotate([90, 0, 0]) cylinder(r=hinge_pin_r, h=100, center=true, $fn=50);
        // nut hole
        translate([width/5, -20, height - nut_depth]) cube([nut_width, 50, nut_depth], true);
        // axle hole
        translate([width/5, 0, 0]) rotate([0, 0, 0]) cylinder(r=rod_r, h=100, center=true, $fn=50);

        // remove the top for printing
        #translate([width / 2 - 2, 0, height]) cube([width, 50, nut_depth], true);
}

include <coax_sizes.scad>

module coax_leg() {
        difference() {
                union() {
                        translate([5, 0, leg_r/2])
                                rotate([0, -90, 0]) {
                        	cylinder(h = leg_h, r = leg_r, center = false, $fn=3);
                        }
                        translate([0, -leg_r, 0])
                                cube([1.5, leg_r * 2, leg_r * 1.5], false);
                }

                // round the end
                difference() {
                        translate([-7 - leg_r * 1.2, 0, leg_r * 1.2 / 2])
                                cube([leg_r * 1.2, leg_r * 1.2 * 2, leg_r * 1.2 * 2], true);
                        translate([-7, 0, leg_r * 1.2 / 2])
                                sphere(leg_r * 1.2, $fn=50);
                }
        }
}

module coax_legs () {
        union() {
                for(i = [1 : legs]) {
                        translate([0, 10 * i - (legs / 1.5) * 10, 0]) coax_leg();
                }
        }
}

coax_legs();

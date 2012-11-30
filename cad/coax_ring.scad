include <coax_sizes.scad>

module coax_ring () {
        translate([0, 0, ring_h / 2])
        difference() {
                union() {
                        // sleeve
                        cylinder(h = ring_h, r = ring_outside_r, center = true, $fn=120);

                        // attachment body
                        translate([ring_body_w, 0, 0])
                                cube([ring_body_w, ring_body_d, ring_h], true);
                }

                // center hole
                cylinder(h = ring_h * 3, r = ctr_outside_r + .25, center = true, $fn=120);

                // nut cutout
                translate([ring_body_w + .5, 0, rod_up_from_base])
                        #cube([nut_width, nut_depth, rod_up_from_base * 4], true);

                // axle hole
                translate([ring_body_w + .5, 0, 0])
                        rotate([90, 0, 0])
                        #cylinder(r=rod_r, h=20, center=true, $fn=60);
        }
}

coax_ring();

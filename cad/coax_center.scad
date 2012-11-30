include <coax_sizes.scad>

module coax_center () {
        difference() {
                union() {
                        translate([0,0,ring_h * 1.5]) cylinder(h = ring_h * 3, r = ctr_outside_r, center = true, $fn=120);
                        // bottom
                        translate([0,0,ctr_bottom_h / 2]) cylinder(h = ctr_bottom_h, r = ctr_bottom_r, center = true, $fn=120);
                        // rubber band attachments
                        for (i = [1 : nubs]) {
                                rotate([0, 0, i * 360 / nubs])
                                        translate([ctr_bottom_r + 2.5, 0, ctr_bottom_h / 2])
                                        scale([1, 2, 1])
                                        cylinder(h = ctr_bottom_h, r = nub_r, center = true, $fn=30);
                                rotate([0, 0, i * 360 / nubs])
                                        translate([ctr_bottom_r + 1, 0, ctr_bottom_h / 2])
                                        scale([2, 1, 1])
                                	#cylinder(h = ctr_bottom_h, r = nub_r, center = true, $fn=30);

                        }

                }
                // center hole
                cylinder(h = ring_h * 10, r = pen_hole_r, center = true, $fn=120);

                // legs
                for(i = [1 : legs]) {
                        rotate([0, 0, i * 360 / legs])
                                translate([leg_offset, 0, 0])
                                	cylinder(h = 100, r = leg_hole_r, center = true, $fn=3);

                }
        }
}

coax_center();

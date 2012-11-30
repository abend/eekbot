include <MCAD/boxes.scad>

h = 4.5;
peg_h = 8;
peg_r = 4.5 / 2;
peg_off = 16;

module servo_direct_arm() {
        difference() {
                union() {
                        cylinder(h = h, r = 11, center = false, $fn=100);
                        translate([0, 0, h/2])
                                roundedBox([40, 7.25, h], 3, true);

                        // pegs
                        for(i = [1 : 2]) {
                                rotate([0, 0, 180 * i])
                                translate([peg_off, 0, 0])
                                cylinder(h = peg_h + h, r = peg_r, center = false, $fn=100);
                        }
                }

                // rod hole
                cylinder(h = 40, r = 5/2, center = true, $fn=50);
                // nut hole
                translate([0,0,-1.5]) {
                        #cylinder(h = h, r = 11.2/2, center = false, $fa=60);
                }

        }
}

servo_direct_arm();

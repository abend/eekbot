include <MCAD/involute_gears.scad>

module my_gear() {
        difference() {
                gear(number_of_teeth=20,
                     circular_pitch=176,
                     pressure_angle=10,
                     clearance = 0.2,

                     rim_thickness = 4,
                     rim_width = 5,

                     gear_thickness=1,

                     hub_thickness=7,
                     hub_diameter=15,

                     bore_diameter=0,
                     //twist=12,
                     //flat = false
                     circles = 4
                     );

                translate([0,0,7]) {
                        cylinder(h = 7, r = 11/2, center = true, $fa=60);
                        cylinder(h = 20, r = 5/2, center = true, $fs=1);
                }
        }
}

/* my_gear(); */
/* translate([25,0,0]) my_gear(); */

test_bevel_gear_pair();

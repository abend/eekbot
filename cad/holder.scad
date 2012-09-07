include <MCAD/boxes.scad>


out_depth = 15;

wall_depth = 16;

in_height = 45;
in_length = 26 - (wall_depth / 2);
in_depth = out_depth * 2;

out_length = in_length + wall_depth * 1.5;
out_height = in_height + wall_depth;

cutout_height = 11.5;
rod_hole_height = 23;
rod_radius = 2.8;

//motor_height = 24;

//rotate([90,0,0]) {
difference() {
                //rotate([90,0,0]) 
                //roundedBox([55, 20, 55], 5, true);     
        translate([-wall_depth / 2, -out_depth / 2, 0]) cube([out_length, out_depth, out_height], false);
        translate([wall_depth / 2, -in_depth / 2, (out_height - in_height) / 2]) 
                cube([in_length, in_depth, in_height], false);

        // bottom cutout
        translate([-in_length / 2, -in_depth / 2, wall_depth/2]) 
                cube([in_length, in_depth, cutout_height], false);

        // axle hole
        translate([0,0,40])
        #cylinder(h = 120, r = rod_radius, center = true, $fa=2);

        // 26mm from axle center to 

        // rod hole
        translate([wall_depth * .3, 0, wall_depth / 2 + rod_hole_height]) rotate([0, 90, 0])
                #cylinder(h = 50, r = rod_radius, center = false, $fa = 1);
        }
//}

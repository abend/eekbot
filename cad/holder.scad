include <MCAD/boxes.scad>


out_depth = 12;

wall_depth = 12;

in_height = 45;
in_length = 26 - (wall_depth / 2);
in_depth = out_depth * 2;

motor_height = 24;
bottom_height = motor_height + 5;

out_length = in_length + wall_depth * 1.5;
out_height = in_height + wall_depth + bottom_height;

motor_depth = out_length;
motor_cutout_length = out_length;

cutout_height = 11.5;
rod_hole_height = 24;
rod_radius = 2.8;


translate([0, 0, wall_depth / 2]) rotate([90, 0, 90])
difference() {
        // main bit
        translate([-wall_depth / 2, -out_depth / 2, -bottom_height]) 
                //roundedBox([out_length, out_depth, out_height], 5, 1);
                cube([out_length, out_depth, out_height], false);

        translate([wall_depth / 2, -in_depth / 2, (out_height - in_height - bottom_height) / 2]) 
                cube([in_length, in_depth, in_height], false);

        // bottom gear cutout
        translate([-in_length / 2, -in_depth / 2, wall_depth/2]) 
                cube([in_length, in_depth, cutout_height], false);

        // axle hole
        translate([0,0,40])
                cylinder(h = 200, r = rod_radius, center = true, $fn=50);

        // rod hole
        translate([wall_depth * .3, 0, wall_depth / 2 + rod_hole_height]) rotate([0, 90, 0])
                cylinder(h = 50, r = rod_radius, center = false, $fn = 50);

        // motor cutout
        translate([-wall_depth, -in_depth / 2, -motor_height])
                cube([motor_cutout_length, in_depth, motor_height], false);
}

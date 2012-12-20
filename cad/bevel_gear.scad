include <MCAD/involute_gears.scad>
include <MCAD/lego_compatibility.scad>

module my_bevel_gear_pair (
	gear1_teeth = 20,
	gear2_teeth = 20,
	axis_angle = 90,
	outside_circular_pitch=300)
{
	outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
	outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) +
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

        difference() {
                union() {
                        bevel_gear (
                                    number_of_teeth=gear1_teeth,
                                    cone_distance=cone_distance,
                                    pressure_angle=30,
                                    gear_thickness = 5,
                                    face_width=10,
                                    bore_diameter=0,
                                    outside_circular_pitch=outside_circular_pitch);
                        // fill the middle
                        translate([0,0,0]) cylinder(h = 11, r = 10, center = true, $fa=60);
                }
                // trim some off the top - problematic to print
                translate([0,0,11]) cylinder(h = 12, r = 20, center = true, $fa=60);
                // axle
                scale([1.1,1.1,1]) translate([0,0,-10]) axle(5);
        }

        translate([40,0,0]) //rotate([180,0,0])
                difference() {
                bevel_gear (
                            number_of_teeth=gear2_teeth,
                            cone_distance=cone_distance,
                            pressure_angle=30,
                            face_width=10,
                            bore_diameter=0,
                            gear_thickness = 5,
                            outside_circular_pitch=outside_circular_pitch);
                // trim some off the top - problematic to print
                translate([0,0,11]) cylinder(h = 12, r = 20, center = true, $fa=60);
                // nut hole
                cylinder(h = 40, r = 5/2, center = true, $fs=1);
                // rod hole
                translate([0,0,10]) {
                        cylinder(h = 24, r = 11.2/2, center = true, $fa=60);
                }
        }
}

my_bevel_gear_pair();

include <MCAD/involute_gears.scad>
include <MCAD/lego_compatibility.scad>

module my_bevel_gear_pair (
	gear1_teeth = 40,
	gear2_teeth = 10,
	axis_angle = 90,
	outside_circular_pitch=400)
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

        translate([0,0,+pitch_apex1 /1.5]) {
                difference() {
                        bevel_gear (
                                    number_of_teeth=gear1_teeth,
                                    cone_distance=cone_distance,
                                    pressure_angle=30,
                                    gear_thickness = 5,
                                    face_width=10,
                                    bore_diameter=0,
                                    outside_circular_pitch=outside_circular_pitch);
                        translate([0,0,-10]) axle(5);
                }
	}
        translate([60,0,0])
                difference() {
		bevel_gear (
                            number_of_teeth=gear2_teeth,
                            cone_distance=cone_distance,
                            pressure_angle=30,
                            face_width=10,
                            bore_diameter=0,
                            gear_thickness = 5,
                            outside_circular_pitch=outside_circular_pitch);
                        translate([0,0,-10]) axle(5);
                }
}

my_bevel_gear_pair();

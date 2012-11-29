h = 2.5;
inside = 10;
margin = 3;

difference() {
        union() {
                translate([3.25, 0, h/2])
                        cube(size=[12,inside + margin * 2, h], center = true);
                translate([23, 0, h/2])
                        cube(size=[30, margin * 3, h], center = true);
        }

        translate([0, 0, h/2]) rotate([0, 0, 0])
                cylinder(h = h * 2, r = 11.2/2, center = true, $fa=60);

}

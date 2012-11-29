

//cylinder(h = 10, r1 = 20, r2 = 10, center = true, $fa=10);

top = 23;
bot = 16;
h = 93;
margin = 3;
h_cut = 85;
hinge_w = 7;
hinge_h = 19;
hinge_d = 10;
hinge_pin_r = 1.75;

module leg_sheath() {
        union() {
                difference() {
                        translate([0, 0, h/2]) cube([(max(bot,top) + margin) * 2, (max(bot,top) + margin) * 2, h], true);

                        polyhedron(
                                   points=[ [bot,bot,0],[bot,-bot,0],[-bot,-bot,0],[-bot,bot,0],
                                            [top,top,h],[top,-top,h],[-top,-top,h],[-top,top,h] ],
                   
                                   triangles=[ [0,2,1],[0,3,2],  // bottom
                                               [1,2,6],[1,6,5],
                                               [2,3,7],[2,7,6],
                                               [0,7,3],[0,4,7],
                                               [0,1,5],[0,5,4],
                                               [4,5,6],[4,6,7], ] // top
                                   );

                        // trim top
                        translate([0, 0, 50 + h_cut]) cube([100, 100, 100], true);
                }

                // hinge
                rotate([0, 0, 45]) translate([40, 0, 70]) {
                        difference() {
                                cube([hinge_d + 4, hinge_w, hinge_h], true);
                                // axle hole
                                translate([3, 0, 0]) rotate([0, 0, 0]) cylinder(r=hinge_pin_r, h=100, center=true, $fn=50);
                        }
                }
        }
}


//leg_sheath();

difference() {
        translate([-h / 2, 0, -20]) rotate([0, 90, 0]) rotate([0, 0, -45 + 180]) leg_sheath();
        translate([0, 0, -50]) cube([100, 100, 100], true);
}


difference() {
    union() {
        cylinder(d=20, h=5);
        cylinder(d=6.5, h=20);
    }

    for (i = [0:3]) {
        rotate([0, 0, 90 * i])
        translate([10, 0, 3])
        cube([5, 5, 1], center=true);
    }
}

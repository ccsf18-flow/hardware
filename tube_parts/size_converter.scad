// Units are mm
include <pipe.scad>

bridge_length = 20;

$fn = 32;

difference() {
     cylinder(d1=large_max_od, d2=small_max_od, h=bridge_length, center=true);
     cylinder(d1=large_id, d2=small_id, h=bridge_length+F, center=true);
}

translate([0, 0, bridge_length / 2])
small_side();
translate([0, 0, -bridge_length/2])
scale([1, 1, -1])
large_side();

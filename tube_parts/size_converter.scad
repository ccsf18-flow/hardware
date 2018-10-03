// Units are mm
use <../utils.scad>
include <pipe.scad>

bridge_length = 20;
rect_spacing = small_min_od * 2;

$fn = 32;

module body() {
     translate([-rect_spacing / 2, -rect_spacing / 2, bridge_length / 2])
     rect_array(rect_spacing, rect_spacing, 2, 2) {
          small_side();
     }

     translate([0, 0, -bridge_length/2])
          scale([1, 1, -1])
          large_side();

     skew_amount = rect_spacing / (2 * bridge_length);

     // translate([rect_spacing / 2, 0, -bridge_length / 2])
     difference() {
          for (i = [1:4]) {
               rotate([0, 0, 90 * i])
                    hull () {
                    translate([rect_spacing / 2, rect_spacing / 2, bridge_length / 2 - 2])
                         cylinder(d=small_min_od, h=2);
                    translate([0, 0, -bridge_length / 2])
                         cylinder(d=large_max_od, h=2);
               }
          }
          for (i = [1:4]) {
               rotate([0, 0, 90 * i])
                    hull () {
                    translate([rect_spacing / 2, rect_spacing / 2, bridge_length / 2 - 2 + F])
                         cylinder(d=small_id, h=2);
                    translate([0, 0, -bridge_length / 2 - F])
                         cylinder(d=large_id, h=2);
               }
          }
     }
}

body();

/*
difference() {
     cylinder(d1=large_max_od, d2=small_max_od, h=bridge_length, center=true);
     cylinder(d1=large_id, d2=small_id, h=bridge_length+F, center=true);
}

translate([0, 0, bridge_length / 2])
small_side();

*/

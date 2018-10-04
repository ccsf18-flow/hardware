// Units are mm
use <../utils.scad>
include <pipe.scad>

F = 0.01;
bridge_length = 20;
rect_spacing = small_min_od * 2;

$fn = 32;

module bridge(outer) {
     n_outputs = 8;
     for (i = [1:n_outputs]) {
          rotate([0, 0, (360 / n_outputs) * i])
               hull () {
               translate([rect_spacing / 2, rect_spacing / 2, bridge_length / 2 - 2])
                    cylinder(d=outer?small_min_od:small_id, h=(outer ? 2 : (2 + F)));
               translate([0, 0, -bridge_length / 2 - (outer ? 0 : F)])
                    cylinder(d=outer?large_max_od:large_id, h=2);
          }
     }

     if (!outer) {
          echo(rect_spacing - small_max_od - 0.5);
          cylinder(r = rect_spacing - small_max_od - 0.5, 100);
     }
}

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
          bridge(true);
          bridge(false);
     }
}

// rotate([0, 180, 0])
body();

// Units are mm
include <pipe.scad>

unit_width = 30;
sluice_thickness = 2;
sluice_width = unit_width * 4 / 5;
sluice_height = sluice_width;
wall_thickness = 5;
sluice_retain = 2;

module outlet_geometry() {
     for (i = [0:3]) {
          translate([unit_width / 2, ((i % 2) - 0.5) * small_max_od * 1.1, (i - 1) * (small_max_od * 1.1) - 3])
               rotate([0, 90, 0])
               children();
     }
}

module valve_body() {
     difference() {
          // Main body
          union() {
               cube([unit_width, unit_width, unit_width], center=true);

               outlet_geometry() {
                    $fs=0.1;
                    small_side();
               }
          }

          //Flow paths
          union() {
               $fs = 0.1;
               // Primary through path
               rotate([0, 90, 90])
               cylinder(d=large_id, h=2*sluice_width, center=true);

               // Interface with The sluice hole
               translate([large_id / 4 + wall_thickness / 2, 0, 0])
               cube([large_id / 2 + wall_thickness, unit_width - 2 * wall_thickness, large_id], center=true);

               // The 4 outlets
               #outlet_geometry() {
                    translate([0, 0, -wall_thickness])
                    cylinder(d=small_id, h=10);
               }
          }

          // Sluice gate hole
          translate([unit_width / 2 - wall_thickness - sluice_thickness / 2, 0, wall_thickness])
               cube([sluice_thickness, sluice_width + F, sluice_height + F], center=true);
     }
}

intersection() {
     valve_body();

     // translate([0, 0, 25])
     //      cube([50, 50, 50], center=true);
}

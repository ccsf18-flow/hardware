// Units are mm
include <../servo.scad>
include <pipe.scad>
include <sluice_defs.scad>

small_hose_clamp_id = 6;
small_hose_clamp_inset = 1;

module outlet_geometry() {
     for (i = [0:3]) {
          translate([unit_width / 2, ((i % 2) - 0.5) * small_max_od * 1.1, (i - 1) * (small_max_od * 1.1) - 3])
               rotate([0, 90, 0])
               children();
     }
}

module small_hose_clamp(h, center=false) {
     difference() {
          // The main body
          cylinder(d=small_hose_clamp_id+wall_thickness, h=h, center=center);

          // Through-hole
          translate([0, 0, center?0:-F])
               cylinder(d = small_hose_clamp_id - small_hose_clamp_inset, h=h + 2 * F, center=center);

          // Reliefs
          translate([0, 0, center?(-h/4):0])union() {
               translate([0, 0, (h + small_hose_clamp_inset) / 2])
               cylinder(d=small_hose_clamp_id, h=h/2 + F, center=center);

               translate([0, 0, (-small_hose_clamp_inset) / 2])
               cylinder(d=small_hose_clamp_id, h=h/2 + F, center=center);
          }
     }
}

module valve_body() {
     difference() {
          // Main body
          sluice_x_offset = large_id / 4 + wall_thickness / 2;
          union() {
               // Primary body geometry
               cube([unit_width, unit_width, unit_width], center=true);

               // Servo mount
               servo_mount_width = 10;
               translate([-(unit_width - servo_mount_width) / 2, 0, (unit_width + horn_cor_offset) / 2])
                    cube([servo_mount_width, unit_width, horn_cor_offset + servo_width / 2], center=true);


               // Outlet positive features
               outlet_geometry() {
                    $fs=0.1;
                    small_hose_clamp(10);
               }
          }

          //Flow paths
          union() {
               $fs = 0.1;
               // Primary through path
               rotate([0, 90, 90])
               cylinder(d=large_id, h=2*sluice_width, center=true);

               // Interface with The sluice hole
               translate([sluice_x_offset, 0, 0])
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

          // Servo mounting stuff
          translate([sluice_x_offset, 0, unit_width / 2 + horn_cor_offset])
               rotate([0, 90, 0])
               #g90s();
     }
}

intersection() {
     valve_body();

     // translate([0, 0, 25])
     //      cube([50, 50, 50], center=true);
}

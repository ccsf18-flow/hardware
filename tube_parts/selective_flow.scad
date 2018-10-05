// Units are mm
include <../servo.scad>
include <pipe.scad>
include <sluice_defs.scad>

small_hose_clamp_id = 6;
small_hose_clamp_inset = 0.5;
sluice_x_offset = large_id / 4 + wall_thickness / 2;

module outlet_geometry() {
     for (i = [0:1], j = [0:1]) {
          // translate([unit_width / 2, ((i % 2) - 0.5) * small_max_od * 1.1, (i - 1) * (small_max_od * 1) - 3])
          translate([unit_width / 2,
                     (i - 0.5) * (small_hose_clamp_id + wall_thickness / 2),
                     (j - 0.5) * (small_hose_clamp_id + wall_thickness / 2)])
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
          union() {
               // Primary body geometry
               cube([unit_width, unit_width, unit_width], center=true);

               // Servo mount
               servo_mount_width = 9;
               translate([-(unit_width - servo_mount_width) / 2, 0, (unit_width + servo_body_depth / 2) / 2])
                    cube([servo_mount_width, unit_width, horn_cor_offset + servo_body_depth / 4], center=true);


               // Outlet positive features
               outlet_geometry() {
                    $fs=0.1;
                    small_hose_clamp(10);
               }

               // Small patch for the hole in the middle of the outlets
               translate([unit_width / 2 + 5, 0, 0])
                    cube([10, 4, 4], center=true);

               // Inlet for testing
               translate([0, unit_width / 2, 0])
                    rotate([270, 0, 0])
                    large_side();
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
                    cylinder(d=small_hose_clamp_id, h=6);
               }
          }

          // Sluice gate hole
          color("red")
               translate([unit_width / 2 - wall_thickness - sluice_thickness / 2, 0, (unit_width - large_id) / 2 - 3])
               cube([sluice_thickness, sluice_width + F, sluice_height + F], center=true);

          // Servo mounting stuff
          translate([sluice_x_offset - 1, 0, unit_width / 2 + horn_cor_offset])
               rotate([90, 0, 90])
               #g90s($fs=0.1);
     }
}

!intersection() {
    union() {
          valve_body();
          translate([sluice_x_offset + (sluice_thickness - sluice_clearance) * 2, 0, 30])
          rotate([270, 0, 90])
          translate([-(sluice_width - sluice_clearance) / 2, 0, 0])
          %sluice_gate();
    }

     // translate([0, 50, 0])
     // cube([100, 100, 100], center=true);
}

include <sluice_gate.scad>

// Units are mm
include <../servo.scad>
include <pipe.scad>
include <sluice_defs.scad>

small_hose_clamp_id = 6;
small_hose_clamp_inset = 0.5;
sluice_x_offset = large_id / 4 + wall_thickness / 2;

module outlet_geometry() {
     for (i = [0:3]) {
          rotate([0, 0, (i / 3 - 0.5) * 120])
               translate([unit_width * 0.3, 0, -unit_width / 2])
               rotate([0, 180, 0])
               children();
     }
}

module valve_body() {
     difference() {
          // Main body
          union() {
              hull() {
                  // Primary body geometry
                  cube([unit_width, unit_width, unit_width], center=true);


                  // Outlet positive features
                  outlet_geometry() {
                        cylinder(r=small_hose_clamp_id, h = wall_thickness);
                  }
              }

              // Servo mount
              servo_mount_width = 15;
              translate([0, 0, (horn_cor_offset + unit_width + servo_horn_height) / 2])
                   cube([servo_mount_width, 20, servo_horn_height + horn_cor_offset], center=true);
          }

          //Flow paths
          union() {
               $fs = 0.1;
               // Primary through path
               rotate([0, 90, 90])
               cylinder(d=large_id, h=2*sluice_width, center=true);

               cube(unit_width - 2 * wall_thickness, center=true);

               // Interface with The sluice hole
               translate([sluice_x_offset, 0, 0])
                    cube([large_id / 2 + wall_thickness, unit_width - 2 * wall_thickness, large_id], center=true);

               // The 4 outlets
               #outlet_geometry() {
                    translate([0, 0, -wall_thickness - F])
                    cylinder(d=small_hose_clamp_id, h=20);
               }

               translate([0, 0, -unit_width / 2 + wall_thickness - oring_dia + F])
               difference() {
                    $fs=0.01;
                    dia = unit_width - 2 * wall_thickness;
                    cylinder(d=dia, h = oring_dia);
                    translate([0, 0, -F])
                         cylinder(d=dia-oring_dia*2, h = oring_dia + 2 * F);
               }
          }

          // Servo mounting stuff
          translate([0, 0, horn_cor_offset + unit_width / 2])
               rotate([0, 180, 0])
               #g90s($fs=0.1);

          cylinder(d=stem_dia, h=100);
     }
}

module top_cut() {
    translate([0, 0, unit_width / 2 - wall_thickness - F])
        union() {
        rotate([0, 0, 45])
              cylinder(d1=(unit_width - 2 * wall_thickness) * sqrt(2),
                      d2=(unit_width+2*F) * sqrt(2),
                      h=wall_thickness + 2*F,
                      $fn=4);
        translate([-unit_width - F, -unit_width - F, wall_thickness])
              cube([unit_width * 2, unit_width * 2, 100]);
    }
}

RENDER_COMPONENT=1;

intersection() {
    union() {
          valve_body();
          // Inlet for testing
          translate([0, unit_width / 2, 0])
               rotate([270, 0, 0])
               large_side();

          %translate([0, 0, -unit_width / 2 + wall_thickness])
                rotate([0, 0, 0])
          sluice_gate();
    }

    if (RENDER_COMPONENT == 1) {
         translate([0, -50, 0])
              cube([100, 100, 100], center=true);
    } else if (RENDER_COMPONENT == 2) {
         top_cut();
    } else if (RENDER_COMPONENT == 3) {
         difference() {
              cube([300, 300, 300], center=true);
              top_cut();
         }
    }
}

use <sluice_gate.scad>

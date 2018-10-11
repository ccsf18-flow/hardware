include <sluice_defs.scad>

module sluice_gate() {
     cleared_width = unit_width - 2 * (wall_thickness + sluice_clearance);
     thicc = sluice_thickness - sluice_clearance;

     // Main body of the sluice
     difference() {
          $fs=0.5;
          union() {
               cylinder(d=cleared_width, h = thicc);
               cylinder(d=stem_dia - sluice_clearance, h=unit_width + horn_cor_offset - wall_thickness);
               // Top cup geometry
               translate([0, 0, unit_width + horn_cor_offset - wall_thickness])
                    difference() {
                        cylinder(d=stem_dia - sluice_clearance, h=cup_height);
                        translate([0, 0, 1])
                        cylinder(d=4.9, h=cup_height+0.01);
                    }
          }

          #translate([-stem_dia + cleared_width / 2, -cleared_width / 2, -0.01])
               cube([cleared_width, cleared_width, 100]);

          rotate([0, 0, 50])
          #translate([-stem_dia + cleared_width / 2, -cleared_width / 2, -0.01])
               cube([cleared_width, cleared_width, 100]);

          rotate([0, 0, -50])
          #translate([-stem_dia + cleared_width / 2, -cleared_width / 2, -0.01])
               cube([cleared_width, cleared_width, 100]);
     }
}

sluice_gate();

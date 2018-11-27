include <pipe.scad>

tube_dia = (5 / 8) * 25.4;
up_tube_offset = 4;
up_tube_height = 23;
up_tube_angle = 21;
body_width = 10;

$fs = 0.2;

module acrylic_tube(h, fill) {
     tube_wall_thickness = (5/8 - 1/2) / 2 * 25.4;
     color("white", alpha=0.8) difference() {
          outside_dia = tube_dia + (fill ? 1 : 0);
          cylinder(d = outside_dia, h=h);
          if (!fill) {
               translate([0, 0, -F])
                    cylinder(d=tube_dia - 2 * tube_wall_thickness, h = h + 2 * F);
          }
     }
}

// translate([-body_width, 0, 0])
//   rotate([0, 90, 180]) large_side();

difference() {
     union() {
          translate([body_width * 0.15, 0, 0])
            rotate([0, 90, 0]) large_side();
          // cylinder(h=up_tube_height, d=tube_dia + 5);
          hull() {
              sphere(d=large_max_od, h=1, center=true);

              cylinder(d=large_max_od, h=1, center=true);

              rotate([0, 90, 0])
              cylinder(d=large_max_od, h=3);

              translate([up_tube_offset, 0, up_tube_height / 3])
              sphere(d=large_max_od * 0.6, h=1);
          }
          // cube([large_max_od, large_max_od, up_tube_height], center=true);

          translate([up_tube_offset, 0, 0])
          for (i = [0:3]) {
               rotate([0, 0, 45 + 90 * i])
                    rotate([0, up_tube_angle, 0])
                    translate([0, 0, 15]) {
                    translate([0, 0, -10])
                         cylinder(d = small_max_od, h = 10);
                    small_side();
               }
          }
     }

     union() {
          translate([up_tube_offset, 0, 0])
          for (i = [0:3]) {
               rotate([0, 0, 45 + 90 * i])
                    rotate([0, up_tube_angle, 0]) {
                    cylinder(d=small_id, h = 30);
               }
          }

         translate([large_max_od / 4, 0, 0])
          rotate([0, 90, 0]) cylinder(h=large_max_od / 2, d2=large_id * 1.1, d1=large_id * 0.3, center=true);
          rotate([0, 90, 90]) cylinder(h=large_max_od, d=large_id * 0.3, center=true);
          // acrylic_tube(up_tube_height + 0.2, true);
     }
}


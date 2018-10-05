include <pipe.scad>
include <../servo.scad>

wall_thickness = 5;
inlet_length = 5;
flapper_dia = small_min_od + 3;
body_dia = flapper_dia + wall_thickness;
body_length = body_dia;
valve_inlet_size = small_min_od + 2;
stem_dia = 2;

module body() {
     difference() {
          $fs = 0.1;
          union() {
               // Inlet tube
               translate([0, 0, -body_length / 2 - inlet_length])
                    rotate([0, 180, 0])
                    small_side();

               // Main valve body
               cylinder(d=valve_inlet_size, h=body_length + 2 * inlet_length, center=true);
               // cylinder(d1=servo_width - F, d2=valve_inlet_size, h=body_length/2);
               // rotate([0, 180, 0])
               //      cylinder(d1=servo_width - F, d2=valve_inlet_size, h=body_length/2);

               // outlet tube
               translate([0, 0, body_length / 2 + inlet_length])
                    small_side();

               // Block for mounting the servo
               translate([0, 0, 0])
                    cube([servo_width - F, body_dia, body_dia], center=true);

               translate([0, body_dia, 0])
                    cube([servo_width - F, body_dia, body_dia + 2 * inlet_length], center=true);
          }

          union() {
               sphere(d = flapper_dia);

               // Main through lines
               cylinder(d=small_min_od, h=body_length+2*(F+inlet_length - 3), center=true);

               // Necking down to the outlet
               translate([0, 0, body_length / 2 + inlet_length - 3])
                    cylinder(d1=small_min_od, d2=small_id, h=3 + F);
               rotate([0, 180, 0])
               translate([0, 0, body_length / 2 + inlet_length - 3])
                    cylinder(d1=small_min_od, d2=small_id, h=3 + F);

               // Valve stem hole
               #rotate([-90, 0, 0])
               cylinder(d=stem_dia, h = body_length / 2 + F);

               translate([0, body_length / 2, 0])
               rotate([90, 0, 0])
               #g90s();
          }
     }
}

intersection() {
     body();

     translate([50, 0, 0])
          cube([100, 100, 100], center=true);
}

// outlet_path();

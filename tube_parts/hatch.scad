// Units are mm
use <../servo.scad>
use <../vendor/parametric_involute_gear.scad>

circular_pitch = 200;
function gear_radius(x) = circular_pitch * x / 360;

F = 0.01;
C = 0.1;
outlet_width = 15;
wall_thickness = 2.5;
body_width = max(outlet_width, 26) + 2 * wall_thickness;
depth = body_width + 20;
shaft_dia = 3;
servo_height = 12.2;
height = servo_height + (gear_radius(32) + gear_radius(8));
shaft_y = wall_thickness + shaft_dia / 2 + 6;
shaft_z = height - wall_thickness - (shaft_dia / 2);
outlet_height = height - servo_height + F - wall_thickness;
gear_thickness = 8;
gear_clearance = C;

module servo_cutout() {
     g90s($fs=0.1);
     // Keep the face clear
     translate([0, 5.8, -5 - F])
     cube([12.4, 34, 12], center=true);

     // hacky wire cutout
     translate([0, -8, -70])
          cube([8, 4, 100], center=true);
}

module body() {
     difference() {
          union() {
               // The main body of the unit
               cube([body_width, depth, height]);
          }

          // Shaft cutout
          translate([-F, shaft_y, shaft_z])
               rotate([0, 90, 0])
               cylinder(d=shaft_dia+4*C, h=body_width + 2*F, $fs=0.05);

          // Cutout so that the shaft can actuall be put in place
          translate([-F + wall_thickness + outlet_width, shaft_y - shaft_dia/2 - 2*C, shaft_z])
              cube([body_width - outlet_width - wall_thickness + 2 * F, shaft_dia + 4 * C, height - shaft_z + F]);

          // Outlet cutout
          translate([wall_thickness, -F, wall_thickness + servo_height + wall_thickness])
               cube([outlet_width, shaft_y + 2 * wall_thickness, height - servo_height - wall_thickness]);

          // Resevoir cutout
          translate([wall_thickness, shaft_y + wall_thickness, servo_height + 2 * wall_thickness])
               cube([body_width - 2 * wall_thickness,
                     depth - shaft_y - 2 * wall_thickness,
                     outlet_height]);


          // Servo cutout
          translate([body_width + 4 + F, shaft_y - F, servo_height / 2 + wall_thickness])
               rotate([0, 90, 0])
               rotate([0, 0, 0])
               servo_cutout();
     }
}

module shaft() {
     $fs = 0.1;
     rotate([0, 90, 0]) {
          cylinder(d=shaft_dia, h = body_width + gear_thickness + C);

          translate([0, 0, wall_thickness + C])
               hull() {
               cylinder(d = shaft_dia, h = outlet_width - 2 * C);

               translate([outlet_height - 2 * wall_thickness - shaft_dia - C, 0, 0]) {
                    cylinder(d = shaft_dia, h = outlet_width - 2 * C);
               }
          }


          rotate([0, 0, 45])translate([0, 0, body_width + C]) {
               difference() {
                    gear(number_of_teeth=32,
                         circular_pitch=circular_pitch,
                         gear_thickness=gear_thickness,
                         rim_thickness=gear_thickness,
                         hub_thickness=gear_thickness,
                         bore_diameter=shaft_dia-F,
                         clearance=gear_clearance,
                         $fs=0.1);
                    rad = gear_radius(32);

                    translate([0, 0, -F])
                    for (i = [0:3]) {
                         $fs = 0.1;
                         rotate([0, 0, 90 * i])
                              color("red")
                              hull() {
                              translate([wall_thickness + 1, wall_thickness + 1, 0])
                                   cylinder(r=2, h = gear_thickness + 2 * F);
                              translate([rad * 0.7 - wall_thickness, wall_thickness + 1, 0])
                                   cylinder(r=2, h = gear_thickness + 2 * F);
                              translate([wall_thickness, rad * 0.7 - wall_thickness, 0])
                                   cylinder(r=2, h = gear_thickness + 2 * F);

                              intersection() {
                                   translate([wall_thickness, wall_thickness, -F])
                                        cube([rad, rad, gear_thickness + 4 * F]);
                                   cylinder(r = rad * 0.8, h = gear_thickness + 2 * F);
                              }
                         }
                    }
               }

               color("green", alpha=0.5) translate([0, 0, 1]) {
                    %cylinder(d=circular_pitch * 32 / 180, h = 3);
               }
          }
     }
}

module servo_gear() {
     rotate([0, 90, 0]) {
          gear(number_of_teeth=8,
               circular_pitch=circular_pitch,
               gear_thickness=gear_thickness,
               rim_thickness=gear_thickness,
               hub_thickness=gear_thickness,
               bore_diameter=4.9,
               clearance=gear_clearance,
               $fs=0.1);

          color("green", alpha=0.5) translate([0, 0, 1]) {
               %cylinder(d=circular_pitch * 8 / 180, h = 3);
          }
     }
}

body();
translate([0, shaft_y, shaft_z]) shaft();
translate([body_width + C, shaft_y - F, servo_height / 2 + wall_thickness]) servo_gear();

// !servo_cutout();

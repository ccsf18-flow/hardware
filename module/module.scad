// Units are mm

/* [Group 1] */
hatch_angle = 0;

use <../utils.scad>
include <../defs.scad>
use <../servo.scad>
use <../vendor/parametric_involute_gear.scad>

circular_pitch = 200;
function gear_radius(x) = circular_pitch * x / 360;
function gear_center_dist(x, y) = (x + y) * circular_pitch / 360;

tube_dia = (5/8) * 25.4; // 1 inch in mm
module_width = 6 * tube_dia;
base_height = 0.5 * 25.4;
top_height = 0.128 * 25.4;
retaining_wall_height = 5;
wall_thickness = 2.5;
window_height = module_width - (base_height + top_height);
num_led = 3;
led_dia = 20;
led_height = 5;
led_wire_rad = led_dia / 2 - wire_dia;
led_unit_size = 0.95 * module_width / num_led;
drain_hole_offset = module_width * 0.3;
drain_hole_dia = 10;
window_thickness = 0.125 * 25.4; // 1/8" in mm
window_instep = window_thickness;
pump_min_height = 3.5 * 25.4;
valve_body_height = 15;
shaft_dia = 5;
hatch_height = valve_body_height;
gear_thickness = 5;
hatch_gear_teeth = 24;
servo_gear_teeth = 8;
wire_dia = 5;
F = 0.01;
C = 0.2;

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

module acrylic_pattern(h, fill=false) {
    // tube_array_frac = 0.95 / 3;
    // translate([-module_width * (tube_array_frac / 2), -module_width * (tube_array_frac / 2)])
    //     rect_array(module_width * tube_array_frac, module_width * tube_array_frac, 2, 2)
        acrylic_tube(h, fill=fill);
}

module led_pattern() {
    unit_size = led_unit_size;
    n = num_led - 1;

    translate([-unit_size, -unit_size, -led_height + F]) {
         for (i = [0:num_led-1]) {
              translate([unit_size * i, 0, 0]) children();
              translate([unit_size * i, 2 * unit_size, 0]) children();
         }

         for (i = [1:num_led - 2]) {
              translate([0, unit_size * i, 0]) children();
              translate([2 * unit_size, unit_size * i, 0]) children();
         }
    }
}

module tube(od, wall, h) {
     difference() {
          cylinder(d=od, h=h);
          translate([0, 0, -F])
               cylinder(d=od-2*wall, h=h+2*F);
     }
}

module base() {
    foot_percent = 0.2;
    difference() {
        union () {
            // Main body geometry
            translate([0, 0, base_height / 2])
                cube([module_width, module_width, base_height], center=true);

            corner_offset = -module_width * (0.5 + -foot_percent / 2);
            // Temporarily shorten the legs for faster prototyping
            // leg_height = 30;
            leg_height = pump_min_height;
            translate([corner_offset, corner_offset,  base_height + -leg_height / 2])
            rect_array(module_width * (1 - foot_percent), module_width * (1 - foot_percent), 2, 2)
                cube([module_width * foot_percent, module_width * foot_percent, leg_height], center=true);

            // Small walls to contain resin flow
            translate([0, 0, -retaining_wall_height / 2])
            difference() {
                id = module_width - 2 * wall_thickness;
                cube([module_width, module_width, retaining_wall_height], center=true);
                translate([0, 0, -F]) cube([id, id, retaining_wall_height + 3 * F], center=true);
            }

            // Walls for the drainage holes
            translate([-drain_hole_offset / 2, -drain_hole_offset / 2, -retaining_wall_height])
                rect_array(drain_hole_offset, drain_hole_offset, 2, 2)
                cylinder(d=drain_hole_dia + wall_thickness, h=retaining_wall_height);
        }

        union() {
            // LEDs
            translate([0, 0, base_height])
                led_pattern()
                led();

            // Tube through hole
            color("red") translate([0, 0, -F])
                acrylic_pattern(base_height + 2 * F, true);

            // Wall insteps
            color("lightgreen") translate([0, 0, base_height - 0.125 * 25.4])
            windows();

            // Drainage holes
            translate([-drain_hole_offset / 2, -drain_hole_offset / 2, -retaining_wall_height - F])
                rect_array(drain_hole_offset, drain_hole_offset, 2, 2)
                cylinder(d=drain_hole_dia, h=retaining_wall_height + base_height + 2 * F);
        }
    }

    support_standoff = 0.2;

    // "support material"
    color("white") translate([0, 0, base_height + support_standoff]) led_pattern() {
         tube(2*led_wire_rad + 4, 1, h=led_height - support_standoff);
         tube(2*led_wire_rad - 2, 1, h=led_height - support_standoff);
    }
}

module valve_body() {
     difference() {
          union() {
               // Main body volume
               translate([0, 0, valve_body_height / 2])
                    cube([module_width * 0.5,
                          module_width * 0.5,
                          valve_body_height], center=true);

               // Anchor points for the gate
               for (i = [0:1]) {
                    translate([(i - 0.5) * module_width / 2, module_width / 4, valve_body_height / 2 + shaft_dia]) {
                         cube([wall_thickness, 2 * shaft_dia, 1.5 * hatch_height], center=true);
                    }
               }
          }

          union() {
               // Resevoir
               translate([0, 0, valve_body_height / 2])
                    cube([module_width * 0.5 - 2 * wall_thickness,
                          module_width * 0.5 - 2 * wall_thickness,
                          valve_body_height + F], center=true);

               // Front side dump path
               translate([0, module_width * 0.375, valve_body_height / 2])
                    cube([module_width - (2 * wall_thickness),
                          module_width * 0.25 - (2 * wall_thickness),
                          valve_body_height + F], center=true);

               translate([0, module_width / 4, valve_body_height - (hatch_height) / 2])
                    cube([module_width / 2 - (2 * wall_thickness), shaft_dia + F, hatch_height + F], center=true);

               // Servo cut
               // Shaft through hole
               translate([0, module_width / 4, valve_body_height + shaft_dia])
                    rotate([0, 90, 0])
                    cylinder(d=shaft_dia + 2 * C, h = module_width, center=true);

               // Cutout to make the shaft insertable
               translate([module_width / 4, module_width / 4, valve_body_height + -2 * shaft_dia + 30])
                    cube([2 * (wall_thickness + F), shaft_dia + 2 * C, 30], center=true);
          }
     }


     // Servo support
     difference() {
          translate([module_width / 4 - 5, module_width / 4 - 10, valve_body_height])
               hull() {
               translate([4, 0, -valve_body_height]) cylinder(d=5, valve_body_height);
               cylinder(d=10, h=20);
               translate([-5, 0, 0]) cube([5, 5, 20]);
          }

          servo_angle = 34;
          translate([module_width / 4 + gear_thickness + wall_thickness,
                     module_width / 4 - gear_center_dist(hatch_gear_teeth, servo_gear_teeth) * cos(servo_angle),
                     valve_body_height + shaft_dia + gear_center_dist(hatch_gear_teeth, servo_gear_teeth) * sin(servo_angle)])
          {
               rotate([180, -90, 0])
                    #g90s();
               translate([-12, 0, -6.2])
               #cube([10, 10, 12.4]);
          }

     }
}

module water_path() {
     path_width = module_width - 8 * window_instep;
     rotate([0, -6, 0])
     #cube([0.125 * 25.4, path_width, 30], center=true);
}

module sprayer() {
     sprayer_width = 10;
     difference() {
          hull() {
               translate([0, 0, 0.5])
                    cube([sprayer_width, sprayer_width, 1], center=true);

               translate([sprayer_width / 2 , 0, sprayer_width / 2 ])
                    rotate([90, 0, 0])
                    cylinder(d=sprayer_width / 4, h=sprayer_width, center=true);

               translate([sprayer_width, 0, sprayer_width / 2 ])
                    rotate([90, 0, 0])
                    cylinder(d=sprayer_width / 4, h=sprayer_width, center=true);
               translate([sprayer_width, 0, 0.5])
                    cube([1, sprayer_width, 1], center=true);
          }

          translate([sprayer_width, 0, sprayer_width / 4])
               rotate([0, 6, 0]) {

               translate([-1.5 + F, 0, 0])
                    rotate([0, -90, 0])
                    cylinder(h=100,d=6);


               translate([0, (sprayer_width - wall_thickness) / 3, 0])
                    cube([3, (sprayer_width - wall_thickness) / 2, 1], center=true);

               translate([0, -(sprayer_width - wall_thickness) / 3, 0])
                    cube([3, (sprayer_width - wall_thickness) / 2, 1], center=true);

               translate([-0.75, 0, 0])
                    cube([1.5, (sprayer_width - wall_thickness) / 2, 1], center=true);
          }
     }
}

// !sprayer();

module top() {
    difference() {
         union() {
              translate([0, 0, top_height / 2])
                   cube([module_width, module_width, top_height], center=true);

              translate([0, 0, top_height])
              for (i = [0:3]) {
                   rotate([0, 0, 45 + 90 * i])
                        translate([module_width / 6, 0, 0])
                        // rotate([0, 0, 90])
                        sprayer();
              }
         }

         // Through hole for the water inlet
         translate([0, 0, -F])
              acrylic_pattern(top_height + valve_body_height + 2*F, true);

         // Seat for the walls
         color("green") translate([0, 0, -window_height + 0.125 * 25.4])
               windows();

         // Water outlet ports
         for (i = [0:3]) {
              rotate([0, 0, 90 * i])
                    translate([module_width / 2 - 2 * window_instep, 0, 0])
                    water_path();
         }
    }

    module separator() {
         hull() {
              od = (module_width - wall_thickness) / 2;
              id = (module_width - wall_thickness) / 2 - module_width / 4 + wall_thickness / 2;
              translate([od, od, 0]) cube([wall_thickness, wall_thickness, retaining_wall_height], center=true);
              translate([id, id, 0]) cube([wall_thickness, wall_thickness, retaining_wall_height], center=true);
         }
    }

    // Flow guides
    translate([0, 0, top_height + retaining_wall_height / 2 - F]) {
         // outside walls
         difference() {
              cube([module_width, module_width, retaining_wall_height], center=true);
              cube([module_width - 2 * wall_thickness, module_width - 2 * wall_thickness, retaining_wall_height + F], center=true);
         }
    }
}

module windows() {
    window_size = module_width - 2 * window_instep;
    echo("Window size: ", window_size / 25.4);
    echo("Window height: ", window_height / 25.4);
    color("white", alpha=0.5) for (i = [0:3]) {
        rotate([0, 0, 90 * i])
            translate([(module_width - window_thickness) / 2 - window_instep, 0, window_height / 2])
            cube([window_thickness, window_size, window_height], center=true);
    }
}

led_path_angle = 30;

module led_path(h, t) {
     cylinder(d=wire_dia, h=h + F);
     translate([0, 0, h])
          rotate([0, led_path_angle, 0]) {
          sphere(d=wire_dia);
          cylinder(d=wire_dia, h=t + F);
     }
}

module led() {
    color("orange")
        cylinder(d=led_dia, h=led_height + 3);

    #translate([0, 0, F])
    rotate([0, 180, 0]) {
         t = base_height;
         rotate([0, 0, 0])
              translate([0, led_wire_rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, 60])
              translate([0, led_wire_rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, -60])
              translate([0, led_wire_rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, 180])
              translate([0, led_wire_rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);

         translate([0, 0, base_height + base_height - 4])
              sphere(d=wire_dia + 4);
    }
}

$fs = $render ? 0.25 : 0.1;

translate([0, 0, -40]) {
base();

// translate([0, 0, base_height])
//     acrylic_pattern(window_height);
// translate([0, 0, base_height])
//     windows();

translate([0, 0, window_height + base_height]) {
     top();
}
}


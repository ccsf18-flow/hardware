// Units are mm
use <../utils.scad>
include <../defs.scad>
use <../tube_parts/selective_flow.scad>

tube_dia = (5/8) * 25.4; // 1 inch in mm
module_width = 6 * tube_dia;
base_height = 0.5 * 25.4;
top_height = tube_dia;
window_height = module_width - (base_height + top_height);
led_height = 5;
window_thickness = 0.125 * 25.4; // 1/8" in mm
window_instep = window_thickness;
pump_min_height = 3.5 * 25.4;
wire_dia = 3;
F = 0.01;

module acrylic_tube(h, fill) {
    tube_wall_thickness = (5/8 - 1/2) / 2 * 25.4;
    color("white", alpha=0.8) difference() {
        cylinder(d = tube_dia, h=h);
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
    num_led = 3;
    module_frac = 0.95;
    unit_size = module_frac * module_width / num_led;
    n = num_led - 1;

    translate([-unit_size, -unit_size, -led_height + F]) {
         for (i = [0:num_led-1]) {
              translate([unit_size * i, 0, 0]) led();
              translate([unit_size * i, 2 * unit_size, 0]) led();
         }

         for (i = [1:num_led - 2]) {
              translate([0, unit_size * i, 0]) led();
              translate([2 * unit_size, unit_size * i, 0]) led();
         }
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
            translate([corner_offset, corner_offset,  base_height + -pump_min_height / 2])
            rect_array(module_width * (1 - foot_percent), module_width * (1 - foot_percent), 2, 2)
                cube([module_width * foot_percent, module_width * foot_percent, pump_min_height], center=true);
        }

        union() {
            // LEDs
            translate([0, 0, base_height])
                led_pattern();

            // Tube through hole
            color("red") translate([0, 0, base_height - 0.125 * 25.4])
                acrylic_pattern(0.125 * 25.4 + F, true);

            // Outlet flow path
            translate([0, 0, base_height - 0.125 * 25.4])
                rotate([atan2(module_width / 2 + 25.4, -base_height / 2), 0, 30])
                cylinder(d = tube_dia - 6, h=100);

            // Wall insteps
            color("lightgreen") translate([0, 0, base_height - 0.125 * 25.4])
            windows();
        }
    }
}

module top() {
    difference() {
        translate([0, 0, top_height / 2])
            cube([module_width, module_width, top_height], center=true);

        rotate([0, 180, 0]) {
            led_pattern();
            translate([0, 0, -0.125 * 25.4])
                acrylic_pattern(0.125 * 25.4 + F, true);
        }
    }
}

module windows() {
    window_size = module_width - 2 * window_instep;
    echo("Window size: ", window_size / 25.4);
    color("white", alpha=0.5) for (i = [0:3]) {
        rotate([0, 0, 90 * i])
            translate([(module_width - window_thickness) / 2 - window_instep, 0, window_height / 2])
            cube([window_thickness, window_size, window_height], center=true);
    }
}

led_path_angle = 60;

module led_path(h, t) {
     cylinder(d=wire_dia, h=h + F);
     translate([0, 0, h])
          rotate([0, led_path_angle, 0]) {
          sphere(d=wire_dia);
          cylinder(d=wire_dia, h=t + F);
     }
}

module led() {
    led_dia = 20;
    color("orange")
        cylinder(d=led_dia, h=led_height + 3);

    #translate([0, 0, F])
    rotate([0, 180, 0]) {
         rad = led_dia / 2 - wire_dia;
         t = sin(led_path_angle) * rad;
         rotate([0, 0, 0])
              translate([0, rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, 60])
              translate([0, rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, -60])
              translate([0, rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);
         rotate([0, 0, 180])
              translate([0, rad, 0])
              rotate([0, 0, -90])
              led_path(h=base_height, t=t);

         translate([0, 0, base_height + cos(led_path_angle) * rad])
              sphere(d=wire_dia + 4);
    }
}

$fs = $render ? 0.25 : 0.1;

base();

// translate([0, 0, base_height])
//     acrylic_pattern(window_height);
// translate([0, 0, base_height])
//     windows();

translate([0, 0, window_height + base_height])
   top();

// units are mm
include <../defs.scad>
include <../servo.scad>

F = 0.01;

pipe_spacing = 20;
n_pipe = 4;
base_height = 10;
block_depth = 30;
top_depth = 40;
valve_body_length = 17;
valve_body_hang = 1.3;
valve_body_dia = 8;
body_back_to_stem_t = 10;
stem_dia = 5;
body_back_to_stem_c = body_back_to_stem_t + (stem_dia / 2);
stem_top_to_valve = 11;
stem_height = 23;
stem_center = body_back_to_stem_c - valve_body_hang - tube_dia / 2;
stem_top = stem_top_to_valve + (valve_body_dia) / 2;
handle_rad = 13;
top_side_height = stem_top + servo_horn_height + 3 - F;

module outlet() {
    tube_dia = 7;
    // backplane pipe
    translate([-(pipe_spacing + F) / 2, 0])
    rotate([0, 90, 0])
    cylinder(d = tube_dia, h = pipe_spacing + F);

    translate([0, -valve_body_hang - tube_dia / 2, 0])
    rotate([-90, 0, 0]) {
        // Valve body
        cylinder(d = valve_body_dia, h=valve_body_length);
        // Spacing for the outlet hose
        cylinder(d = 7, h = 30);
    }

    // Valve stem
    translate([0
              , stem_center
              , stem_top - stem_height])
    cylinder(d = stem_dia, h=stem_height);

    // Handle sweep
    intersection() {
        translate([0
                  ,stem_center
                  ,stem_top - 4])
        cylinder(r = handle_rad, 8);

        translate([-50, 0, 0])
        cube([100, 100, 100], true);
    }
}

module outlet_holder() {
    difference() {
        // Base structure
        union() {
            // The foundation
            translate([0, block_depth / 2, base_height / 2])
            cube([pipe_spacing, block_depth, base_height], true);

            // Overhang for the top
            translate([0, top_depth / 2, base_height + (top_side_height) / 2])
            cube([pipe_spacing, top_depth, top_side_height], true);
        }

        #translate([0, 4 + servo_body_depth / 2, base_height]) {
            // Make space for the outlet
            outlet();
            // Make space for the servo
            #
            // Put the output above the valve handle
            translate([0, stem_center, stem_top])
            rotate([0, 180, 180]) // Rotate it into correct orientation
            g90s();

            // Alignment pins
            #translate([0, -10, -9])
            cylinder(d=5, h=20);
        }
    }
}

module all_outlets() {
    union() {
        for (i = [1:n_pipe]) {
            translate([(i-1) * pipe_spacing, 0, 0])
            outlet_holder();
        }
    }
}

module select_segment(segment) {
    intersection() {
         all_outlets();

         if (segment == 1) {
              translate([-pipe_spacing/2, 0, 0])
                   cube([pipe_spacing*n_pipe, 4 + servo_body_depth - 3, base_height]);
         }
         if (segment == 2) {
              translate([-pipe_spacing/2, 0, base_height])
                   cube([pipe_spacing*n_pipe, 4 + servo_body_depth - 3, top_side_height]);
         }
    }
}

all_outlets();

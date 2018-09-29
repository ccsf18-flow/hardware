servo_width = 12;
servo_body_depth = 22.5;
servo_body_height = 22.5;
servo_ear_size = 5;
servo_step_height = 6;
servo_horn_height = 8+servo_step_height;
// servo step diameter is equal to the body width

// We put the center of the object at the center of the output
module g90s() {
    translate([-servo_width / 2, -servo_width / 2, -servo_body_height - servo_horn_height]) {
        // The main body of the servo
        cube([servo_width, servo_body_depth, servo_body_height]);

        // Ears
        translate([0, -servo_ear_size, servo_body_height - 3])
        cube([servo_width, servo_body_depth + 2*servo_ear_size, 3]);

        // The output shaft
        translate([servo_width / 2, servo_width / 2, servo_body_height]) {
            cylinder(d=servo_width, h=servo_step_height);
            // This cylinder goes to the top of the horn, with screw
            cylinder(d=7, h=servo_horn_height);
        }
    }
}

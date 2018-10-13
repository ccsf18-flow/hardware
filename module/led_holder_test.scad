led_dia = 20;
wire_dia = 3;
led_spacing = 4;
N = 4;
h = 5;

difference() {
    cube([N * led_dia + (N + 1) * led_spacing,
          led_dia + 2 * led_spacing,
          h]);

    $fs = 0.1;
    for (i = [0:N-1]) {
        translate([led_spacing + led_dia / 2 +  (led_dia + led_spacing) * i, led_dia / 2 + led_spacing, h - 3]) {
            cylinder(d=led_dia, h = 3.01);

            for (x = [0:1], y = [0:1]) {
                translate([led_dia * (x - 0.5) * 0.5, led_dia * (y - 0.5) * 0.5, -3])
                    cylinder(d=wire_dia, h = 6);
            }
        }
    }
}

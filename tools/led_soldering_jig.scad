led_dia = 12;
wire_len = 50;
wire_dia = 3;
h= 5;

$fs=0.1;
difference() {
     cube([led_dia + 2 * wire_len, led_dia + 5, h], center=true);

     // Main body hole
     translate([0, 0, h/2-3])
          cylinder(d=led_dia, h=10);

     // Alignment with the LED itself
     cube([6, 6, 10], center=true);

     // Wire traces
     translate([0, 0, h/2])
          rotate([0, 90, 0])
          cylinder(d=wire_dia, h=wire_len + led_dia);
     translate([0, 3, h/2])
          rotate([0, 90, 0])
          cylinder(d=wire_dia, h=wire_len + led_dia);
     translate([0, -3, h/2])
          rotate([0, 90, 0])
          cylinder(d=wire_dia, h=wire_len + led_dia);

     translate([0, 0, h/2])
          rotate([0, -90, 0])
          cylinder(d=wire_dia, h=wire_len + led_dia);
}

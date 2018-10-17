h=4;
knob_size = 4;
arm_len = 10;
arm_thickness = 5;
t=3;

module arm() {
     cylinder(r=knob_size, h=h);
     translate([(knob_size + arm_len) / 2, 0, h/2])
     cube([arm_len, arm_thickness, h], center=true);
}

$fs=0.5;

translate([0, -(knob_size + t / 2), 0]) arm();
translate([0,  (knob_size + t / 2), 0]) arm();

translate([knob_size / 2 + arm_len, 0, 0])
intersection() {
     difference() {
          cylinder(r=arm_thickness + t, h=h);
          translate([0, 0, -0.01])
               cylinder(r=t, h=h + 0.02);
     }

     translate([25, 0, 0])
     cube([50, 50, 50], center=true);
}

base_height = 21;
width = 11;
base_thickness = 20;
notch_thickness = 7.5;
F = 0.01;

difference() {
  union() {
    translate([-width, 0, 0])
      cube([2 * width, base_thickness, 5]);
    cube([width, base_thickness, base_height]);
  }

  translate([width * 0.15, -F, base_height - 10])
    rotate([0, -4, 0])
    cube([notch_thickness, base_thickness + 2 * F, base_height]);
}

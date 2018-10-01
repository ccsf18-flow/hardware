// Units are mm
large_id = 15;
small_id = 3;
F = 0.01;

large_min_od = 21;
large_max_od = 22;
large_spacing = 10.5;
large_count = 3;

small_min_od = 5;
small_max_od = 5.5;
small_spacing = 2;
small_count = 3;
small_extension = 5;

module small_pipe(l) {
     difference() {
          cylinder(d=small_min_od, h=l);
          translate([0, 0, -F/2])
               cylinder(d=small_id, h=l+F);
     }
}

module large_pipe(l) {
     difference() {
          cylinder(d=large_min_od, h=l);
          translate([0, 0, -F/2])
               cylinder(d=large_id, h=l+F);
     }
}

module nipple(odmin, odmax, id, spacing, count) {
     difference() {
          for (i = [0:1:count-1]) {
               translate([0, 0, i * spacing])
                    cylinder(d1=odmax, d2=odmin, h=spacing);
          }
          translate([0, 0, -F/2])
               cylinder(d=id, h=spacing * count + F);
     }
}

module small_side() {
     nipple(small_min_od, small_max_od, small_id, small_spacing, small_count);
     translate([0, 0, small_count * small_spacing])
          difference() {
          cylinder(d=small_min_od, h=small_extension);
          translate([0, 0, -F/2])
               cylinder(d=small_id, h=small_extension + F);
     }
}

module large_side() {
     nipple(large_min_od, large_max_od, large_id, large_spacing, large_count);
}

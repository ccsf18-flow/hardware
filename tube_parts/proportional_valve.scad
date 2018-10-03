include <pipe.scad>

valve_primary_dim = 30;
wall_thickness = 5;
inlet_length = 5;
curve_height = 10;

module curve(start, end, control, start_rot, end_rot, n = 10, earlystop=0) {
     for (i = [0:((earlystop == 0) ? n : earlystop)]) {
          f = i / n;
          nf = 1 -f;
          v = (nf) * (nf * start + f * control) + f * (nf * control + f * end);
          r = start_rot * f + end_rot * (1 - f);
          translate(v)
               rotate(r)
               children();
     }
}

module inlet_curve(outer) {
     d = outer ? valve_primary_dim : (valve_primary_dim + F);
     curve([0, 0, 0], // Start
           [d, 0, d], // End
           [d, 0, 0], // control
           [0, 0, 0], // Start rotation
           [0, 90, 0], // End rotation
           n = 15) {
          cylinder(d=outer?large_min_od:large_id, h = curve_height, center=true, $fs=0.08);
     }
}

module outlet_path() {
     difference() {
          hull() {
               translate([0, 0, -1 + valve_primary_dim / 2])
                      cylinder(r=valve_primary_dim - wall_thickness, h = 1);

               translate([valve_primary_dim - 1, 0, -curve_height/ 2])
                    rotate([0, 90, 0])
                    cylinder(r = small_id, h = 1);
          }

          translate([0, 0, -F/2])
               cylinder(d=large_max_od, h=valve_primary_dim / 2 + F);
     }
}

module outlet_block(outer) {
     outlet_block_size = 15;

     translate([valve_primary_dim, 0, valve_primary_dim / 2]) rotate([0, 130, 0])
     {
          translate([0, 0, outlet_block_size])
          if (outer) {
               translate([0, 0, -outlet_block_size]) {
                    sphere(r = small_min_od * 1.1);
                    cylinder(r=small_min_od * 1.1, h = outlet_block_size);
               }
               small_pipe(inlet_length);
               translate([0, 0, inlet_length])
                    small_side();
          } else {
               translate([0, 0, -outlet_block_size - 15])
                    cylinder(d = small_id, h = outlet_block_size + inlet_length + 30);
          }
     }
}

module body() {
     difference() {
          union() {
               // Inlet tubing
               rotate([0, -90, 0])
               translate([0, 0, valve_primary_dim])
               large_pipe(inlet_length);

               translate([-valve_primary_dim - inlet_length, 0, 0])
               rotate([0, -90, 0])
               large_side();

               translate([-valve_primary_dim, 0, 0])
                    inlet_curve(true);

               // Main valve body
               translate([0, 0, -large_max_od / 2])
               cylinder(r = valve_primary_dim, h = valve_primary_dim + curve_height / 2 + large_max_od / 2);

               // Outlet tubing
               outlet_block(true, $fs=0.08);
          }

          union() {
               translate([-valve_primary_dim - F, 0, 0])
                    inlet_curve(false);

               outlet_block(false, $fs=0.08);

               translate([0, 0, (F+curve_height + valve_primary_dim) / 2])
               outlet_path();
          }
     }
}

body();
// outlet_path();

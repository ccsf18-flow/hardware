use <../vendor/threads.scad>
include <pipe.scad>
include <variable_flow_defs.scad>

body_length = 10;
inlet_clearance = 10;
sm_output_len = 40;
sm_output_angle = 30;
base_height = 20;
hole_size = 20;
holes_along_axis = 3;
holes_around_axis = 6;

module body_positive() {
     cylinder(d=large_min_od, h=body_length+2*(inlet_clearance), center=true);

     // Small size outlet
     translate([large_id/2, 0, -body_length]) rotate([0, sm_output_angle, 0]){
          small_pipe(sm_output_len, $fn = pipe_fn);
          translate([0, 0, sm_output_len])
               small_side($fn = pipe_fn);
     }

     hull() {
          plate_thickness = 5;
          translate([large_id / 2 + ((body_length / 2) + inlet_clearance) * sin(sm_output_angle),
                     0,
                     inlet_clearance + body_length / 2 - plate_thickness]) {
               cylinder(h=plate_thickness, r=10);
          }
          translate([0, 0, inlet_clearance])
               cylinder(h=plate_thickness, d=large_min_od*1.5);
     }

     // Input side
     translate([0, 0, -body_length / 2 - inlet_clearance])
          rotate([0, 180, 0])
          large_side();

     // Threading at the end for the cap.
     cap_sz = 5;
     translate([0, 0, inlet_clearance + body_length / 2]) {
          // Diameter is set so that the gutter of the threads is aligned with the main body.
          metric_thread(thread_dia,
                        threads_per_unit,
                        thread_length - cap_sz,
                        leadin=1);
          // Cap off the end
          translate([0, 0, thread_length - cap_sz])
          cylinder(d=large_min_od, h=cap_sz);
     }
}

module outlet_cut() {
     #cylinder(h=large_min_od * sqrt(2) / 2, d1=0, d2=hole_size / 2);
}

module body() {
     // translate([body_length/2, 0, 0])
     //      rotate([0, 90, 0])
     //      large_side();
     difference() {
          body_positive();

          // Hole for the small outlet
          translate([large_id / 2, 0, -body_length]) rotate([0, sm_output_angle, 0]) translate([0, 0, -large_id])
               cylinder(d=small_id, h=100, $fn = pipe_fn);

          // Hole for the main through line
          translate([0, 0, 0])
               cylinder(d=large_id,
                        h=body_length + 2 * inlet_clearance + 1.5*thread_length + F,
                        center=true);

          // Cuts to let fluid out of the threads
          translate([0, 0, body_length + inlet_clearance + 2])
               for (j = [0:1:holes_along_axis-1]) {
                    translate([0, 0, j * 9])
                         rotate([(360 / (2*holes_around_axis)) * j, 90, 0])
                         for (i = [0:1:holes_around_axis - 1]) {
                              rotate([(360 / holes_around_axis) * i, 0, 0])
                                   outlet_cut();
                         }
               }
     }
}

scale([1, 1, -1])
body();


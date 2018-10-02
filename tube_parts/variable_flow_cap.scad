use <../vendor/threads.scad>
include <pipe.scad>
include <variable_flow_defs.scad>

rotate([0, 180, 0])
difference() {
     cylinder(d=thread_dia + 3, h = 10);

     translate([0, 0, -F])
     metric_thread(thread_dia,
                   threads_per_unit,
                   10,
                   internal=true);
}

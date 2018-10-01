use <../vendor/threads.scad>
include <pipe.scad>
include <variable_flow_defs.scad>

difference() {
     cylinder(d=large_min_od * 1.2, h = thread_length + 10);

     translate([0, 0, -F])
     metric_thread(large_min_od + 0.615 * threads_per_unit, threads_per_unit, thread_length);
}

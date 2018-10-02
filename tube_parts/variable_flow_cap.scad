use <../vendor/threads.scad>
include <pipe.scad>
include <variable_flow_defs.scad>

scale([1.1, 1.1, -1])
difference() {
     cylinder(d=thread_dia + 3, h = thread_length + 10);

     translate([0, 0, -F])
     metric_thread(thread_dia,
                   threads_per_unit,
                   thread_length,
                   internal=true);
}

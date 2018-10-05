include <sluice_defs.scad>

module sluice_gate() {
     cleared_width = sluice_width - sluice_clearance;
     thicc = sluice_thickness - sluice_clearance;
     // The primary section what goes in the hole
     cube([cleared_width, sluice_height, thicc]);

     // Put a tab on top of the sluice
     translate([cleared_width / 2, 0, 0])
     cylinder(d=cleared_width, h = thicc);
}

sluice_gate();

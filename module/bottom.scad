use <module.scad>

intersection() {
     rotate([0, 180, 0])
          base();

     translate([19, 19, -10])
     cube([50, 50, 50]);
}

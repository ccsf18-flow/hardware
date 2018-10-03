// Units are mm
use <../utils.scad>
include <../defs.scad>

module_thickness = 5;
module_size = 40;
module_height = 60;
F = 0.01; // Fudge factor

// Find the unitary vector with direction v. Fails if v=[0,0,0].
function unit(v) = norm(v)>0 ? v/norm(v) : undef; 
// Find the transpose of a rectangular matrix
function transpose(m) = // m is any rectangular matrix of objects
  [ for(j=[0:len(m[0])-1]) [ for(i=[0:len(m)-1]) m[i][j] ] ];
// The identity matrix with dimension n
function identity(n) = [for(i=[0:n-1]) [for(j=[0:n-1]) i==j ? 1 : 0] ];

function rotate_from_to(a,b) = 
    let( axis = unit(cross(a,b)) )
    axis*axis >= 0.99 ? 
        transpose([unit(b), axis, cross(axis, unit(b))]) * 
            [unit(a), axis, cross(axis, unit(a))] : 
        identity(3);

module extrude_path(path) {    
    module line(p0, p1) {
        v = p1-p0;
        translate(p0)
          multmatrix(rotate_from_to([0,0,1],v))
            linear_extrude(norm(v) + 1) children(0);
    }
    
    for (i=[1:len(path) - 1]) {
        line(path[i - 1], path[i])
            children(0);
    }
}

module wire_profile() {
    translate([-led_pad_spacing_x, -led_pad_spacing_y/2, 0]) 
    rect_array(led_pad_spacing_x, led_pad_spacing_y, 3, 2) {
        circle(d=wire_dia);
    };
}

module led_cutout() {
    rotate([0, 180, 0]) {
        cylinder(d=led_dia, h = led_h);
        
        translate([-led_pad_spacing_x, -led_pad_spacing_y/2, 0]) 
        rect_array(led_pad_spacing_x, led_pad_spacing_y, 3, 2) {
            cylinder(d=wire_dia, h = module_height+F);
        };
    }
}

module side_holes() {
    wire_fac = 2.5;
    // Translate so everything is lined up on the xy plane
    // grows into -x, and the y axis is the baseline
    translate([-tube_dia - 3 - (wire_fac / 2) * wire_dia
              ,0
              ,-module_thickness - F/2]) {
        // tube hole
        cylinder(d=tube_dia, h = module_thickness +F);
        // Wire pigtail hole
        translate([tube_dia + 3, 0, (module_thickness + F) / 2])
            cube([wire_fac * wire_dia
                 , wire_fac * wire_dia
                 , module_thickness + F], true);
    }
}

// Flip everything upside down
scale([1, 1, -1])
difference() {
    translate([0, 0, module_height / 2]) {
        cube([module_size, module_size, module_height], true);
    }
    
    // Hollow out the inside
    translate([0, 0, (module_height - module_thickness - F) / 2])
        cube([module_size - 2 * module_thickness
             ,module_size - 2 * module_thickness
             ,module_height - module_thickness + F], true);
    
    // Fountain outlet
    
    cylinder(d=tube_dia, h=100);
    
    // LED cutouts
    
    #translate([-module_size / 4, -module_size / 4, module_height+F])
    rect_array(module_size / 2, module_size / 2, 2, 2) {
        led_cutout();
    }
    
    #translate([module_size / 2, 0, 10])
        rotate([0, 90, 0])
        side_holes();
}

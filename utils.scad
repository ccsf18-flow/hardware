module rect_array(x_spacing, y_spacing, n, m) {
     for (i = [0:1:n-1], j =[0:1:m - 1])  {
          translate([i * x_spacing
                     ,j * y_spacing])
               children(i % ($children));
     }
}

module skew(x_skews=[0, 0, 0], y_skews=[0, 0, 0], z_skews=[0, 0, 0], w_skews=[0, 0, 0]) {
     matrix = [
          [1, x_skews[0], x_skews[1], x_skews[2]],
          [y_skews[0], 1, y_skews[1], y_skews[2]],
          [z_skews[0], z_skews[1], 1, z_skews[2]],
          [w_skews[0], w_skews[1], w_skews[2], 1],
          ];

     multmatrix(matrix)
          children();
}

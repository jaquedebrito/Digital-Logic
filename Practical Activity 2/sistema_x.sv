// Practical Task 2 - Digital Logic
`timescale 1ns/10ps

// Module: sistema_x
// Description: This module implements a comparator with a constant using logic gates.
// The output Q is high (1) only when the 4-bit input X is equal to 4'b0101.

module sistema_x(
    input [3:0] X,  // 4-bit input vector
    output Q        // 1-bit output
);

    // Internal wires for inverted inputs
    wire nx3, nx2, nx1, nx0;

    // Invert X[3] and X[1]
    INVX1HVT U1 (nx3, X[3]); // nx3 = ~X[3]
    INVX1HVT U2 (nx1, X[1]); // nx1 = ~X[1]

    // Q = (~X[3]) & X[2] & (~X[1]) & X[0]
    // This matches when X == 4'b0101
    AND4X1HVT A1 (Q, nx3, X[2], nx1, X[0]);

endmodule

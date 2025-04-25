// Module: sistema_y
// Description: Compares two 4-bit inputs A and B for equality using logic gates.
//              Outputs Q = 1 only when A == B

`timescale 1ns/10ps
module sistema_y(
    input [3:0] A,     // 4-bit input A
    input [3:0] B,     // 4-bit input B
    output Q           // Output Q is high when A equals B
);

    // Wires to store intermediate comparison results
    wire xnor3, xnor2, xnor1, xnor0;
    wire [3:0] equals;

    // Compare each bit using XNOR gates (XNOR is 1 when bits are equal)
    XNOR2X1HVT U1 (xnor3, A[3], B[3]);
    XNOR2X1HVT U2 (xnor2, A[2], B[2]);
    XNOR2X1HVT U3 (xnor1, A[1], B[1]);
    XNOR2X1HVT U4 (xnor0, A[0], B[0]);

    // AND all XNOR results to detect complete equality
    AND4X1HVT A1 (Q, xnor3, xnor2, xnor1, xnor0);

endmodule

// Testbench: tb
// Description: Testbench to verify the behavior of the sistema_y module
//              which checks equality between two 4-bit inputs.

`timescale 1ns/10ps
module tb();

    reg [3:0] A, B;   // 4-bit input registers for testing
    wire Q_y;         // Output wire from the module under test

    // Instantiate the sistema_y module
    sistema_y sy(.A(A), .B(B), .Q(Q_y));

    // Stimulus generation
    initial begin
        // Display headers
        $display(" Time   A    B    Q");
        $display(" ===== ==== ==== ===");
        $monitor($time, " %b  %b  %b", A, B, Q_y);
        
        // Test Case 1: A = B (Q should be 1)
        A = 4'b0101; B = 4'b0101; #10;
        
        // Test Case 2: A ≠ B (Q should be 0)
        A = 4'b0101; B = 4'b0100; #10;
        
        // Test Case 3: A = B (Q should be 1)
        A = 4'b1111; B = 4'b1111; #10;
        
        // Test Case 4: A ≠ B (Q should be 0)
        A = 4'b1010; B = 4'b1011; #10;
        
        // Optional: Exhaustive test for all 4-bit combinations
        for(int a = 0; a < 16; a++) begin
            for(int b = 0; b < 16; b++) begin
                A = a; B = b;
                #5;
            end
        end
        
        $finish;
    end

endmodule

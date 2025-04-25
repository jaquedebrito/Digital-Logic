// Combined Testbench: tb
// Description: This testbench verifies the behavior of both sistema_x and sistema_y modules.

`timescale 1ns/10ps
module tb();

    // Signals for sistema_x
    reg [3:0] X;      // 4-bit input for sistema_x
    wire Q_x;         // 1-bit output from sistema_x
    
    // Signals for sistema_y
    reg [3:0] A, B;   // 4-bit inputs for sistema_y
    wire Q_y;         // 1-bit output from sistema_y
    
    // Instantiate both modules
    sistema_x sx(.X(X), .Q(Q_x));
    sistema_y sy(.A(A), .B(B), .Q(Q_y));
    
    // Stimulus generation for sistema_x
    initial begin
        $display("\n===== Testing sistema_x =====");
        $display(" Time    X    Q");
        $display(" ===== ==== ===");
        
        for(int i = 0; i < 16; i++) begin
            X = i;
            #5;
            $display($time, " %b  %b", X, Q_x);
        end
    end
    
    // Stimulus generation for sistema_y
    initial begin
        #100; // Delay to allow sistema_x test to complete
        
        $display("\n===== Testing sistema_y =====");
        $display(" Time   A    B    Q");
        $display(" ===== ==== ==== ===");
        
        // Some sample test cases
        A = 4'b0101; B = 4'b0101; #10;
        $display($time, " %b  %b  %b", A, B, Q_y);
        
        A = 4'b0101; B = 4'b0100; #10;
        $display($time, " %b  %b  %b", A, B, Q_y);
        
        A = 4'b1111; B = 4'b1111; #10;
        $display($time, " %b  %b  %b", A, B, Q_y);
        
        $finish;
    end

endmodule

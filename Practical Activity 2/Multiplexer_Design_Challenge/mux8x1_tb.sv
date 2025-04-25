//JAQUELINE FERREIRA DE BRITO
//CLASS ACTIVITY - 8x1 MULTIPLEXER TESTBENCH

`timescale 1ns/10ps

module tb();
    logic EN;
    logic [3:0] A;
    logic [7:0] X;
    logic Q;
    
    // Instantiation of the module under test
    meu_primeiro_mux8x1 duv (
        .EN(EN),
        .A(A),
        .X(X),
        .Q(Q)
    );
    
    // Stimulus generation
    initial begin
        // Initialization
        EN = 0;
        A = 4'b0000;
        X = 8'b10101010;
        #10;
        
        // Test 1: Verify output is zero when EN=0
        $display("TEST 1: Verify enable signal (EN=0)");
        repeat (4) begin
            A = $random;
            X = $random;
            #10;
            if (Q !== 0) $error("FAILED: Output must be 0 when EN=0, A=%b, X=%b, Q=%b", A, X, Q);
            else $display("PASSED: EN=0, A=%b, X=%b, Q=%b", A, X, Q);
        end
        
        // Test 2: Verify each selection when EN=1
        $display("TEST 2: Verify all possible selections (EN=1)");
        EN = 1;
        X = 8'b10101010; // Alternating pattern for easier verification
        
        for (int i = 0; i < 8; i++) begin
            A = i;
            #10;
            if (Q !== X[i]) $error("FAILED: For A=%d, expected Q=%b, got Q=%b", i, X[i], Q);
            else $display("PASSED: A=%d selects X[%d]=%b, Q=%b", i, i, X[i], Q);
        end
        
        // Test 3: Random values with EN=1
        $display("TEST 3: Random values with EN=1");
        repeat (10) begin
            int addr = $urandom_range(0, 7); // Limited to 0-7 for clarity
            A = addr;
            X = $random;
            #10;
            if (Q !== X[addr]) 
                $error("FAILED: For A=%d, X=%b, expected Q=%b, got Q=%b", addr, X, X[addr], Q);
            else 
                $display("PASSED: A=%d, X=%b, Q=%b", addr, X, Q);
        end
        
        $display("Simulation completed");
        $finish;
    end
    
    // Monitor to display values
    initial begin
        $monitor("Time=%0t, EN=%b, A=%b, X=%b, Q=%b", $time, EN, A, X, Q);
    end
    
endmodule

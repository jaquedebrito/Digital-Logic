// Testbench for Circuito Síncrono 1
module flip_flop_D_tb();
    // Test signals
    logic clk;
    logic reset;
    logic [1:0] entrada;
    logic q;
    
    // Instantiate the device under test (DUT)
    flip_flop_D dut (
        .clk(clk),
        .reset(reset),
        .entrada(entrada),
        .q(q)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns period
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        entrada = 2'b00;
        
        // Release reset
        #10 reset = 0;
        
        // Test case 1: entrada = 00
        #10 entrada = 2'b00;
        
        // Test case 2: entrada = 01
        #10 entrada = 2'b01;
        
        // Test case 3: entrada = 10
        #10 entrada = 2'b10;
        
        // Test case 4: entrada = 11
        #10 entrada = 2'b11;
        
        // Test reset during operation
        #10 reset = 1;
        #10 reset = 0;
        
        // Test additional cases
        #10 entrada = 2'b01;
        #10 entrada = 2'b11;
        
        // End test
        #10 $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t, entrada=%b, q=%b, reset=%b", $time, entrada, q, reset);
    end
endmodule
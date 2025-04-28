// Testbench for Circuito Síncrono 2
module contador_5b_tb();
    // Test signals
    logic clk;
    logic reset;
    logic [4:0] valor_maximo;
    logic [4:0] contagem;
    logic fim;
    
    // Instantiate the device under test (DUT)
    contador_5b dut (
        .clk(clk),
        .reset(reset),
        .valor_maximo(valor_maximo),
        .contagem(contagem),
        .fim(fim)
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
        valor_maximo = 5'd10; // First test with max value of 10
        
        // Release reset
        #10 reset = 0;
        
        // Let counter run for 15 cycles (should see rollover)
        #150;
        
        // Test with different max value
        reset = 1;
        valor_maximo = 5'd3;
        #10 reset = 0;
        
        // Let counter run for 8 cycles (should see multiple rollovers)
        #80;
        
        // Test with max value at maximum of 5 bits
        reset = 1;
        valor_maximo = 5'd31;
        #10 reset = 0;
        
        // Let it run for a few cycles
        #50;
        
        // End test
        #10 $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t, reset=%b, valor_maximo=%d, contagem=%d, fim=%b", 
                 $time, reset, valor_maximo, contagem, fim);
    end
endmodule
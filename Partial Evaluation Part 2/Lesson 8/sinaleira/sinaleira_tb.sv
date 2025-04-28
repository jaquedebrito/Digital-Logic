// Module: sinaleira_tb (Traffic Light Controller Testbench)
// Description: Verification environment for testing the traffic light controller
// Purpose: Simulates the controller behavior by providing clock and pulse inputs
//          and monitors outputs to verify correct operation
module sinaleira_tb();
    // Testbench signals declaration
    logic clk;                 // Clock signal
    logic rst_n;               // Active-low reset signal
    logic pulso;               // Pulse input signal
    logic rua_1_verde;         // Street 1 green light output
    logic rua_1_amarelo;       // Street 1 yellow light output
    logic rua_1_vermelho;      // Street 1 red light output
    logic rua_2_verde;         // Street 2 green light output
    logic rua_2_amarelo;       // Street 2 yellow light output
    logic rua_2_vermelho;      // Street 2 red light output
    
    // Device under test instantiation
    // Connect testbench signals to the controller module
    sinaleira dut (
        .clk(clk),
        .rst_n(rst_n),
        .pulso(pulso),
        .rua_1_verde(rua_1_verde),
        .rua_1_amarelo(rua_1_amarelo),
        .rua_1_vermelho(rua_1_vermelho),
        .rua_2_verde(rua_2_verde),
        .rua_2_amarelo(rua_2_amarelo),
        .rua_2_vermelho(rua_2_vermelho)
    );
    
    // Clock generation process
    // Creates a clock signal with period of 10 time units
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units (10 units period)
    end
    
    // Function to display the current state of traffic lights
    // Prints the status of all lights for both streets
    function void display_state();
        $display("Time=%0t: Street 1 [G=%0d, Y=%0d, R=%0d] | Street 2 [G=%0d, Y=%0d, R=%0d]",
                $time, rua_1_verde, rua_1_amarelo, rua_1_vermelho,
                rua_2_verde, rua_2_amarelo, rua_2_vermelho);
    endfunction
    
    // Stimulus generation and test sequence
    initial begin
        // Initialize all testbench signals
        clk = 0;              // Start with clock low
        rst_n = 0;            // Assert reset (active low)
        pulso = 0;            // Start with pulse low
        
        // Release reset after 10 time units
        #10 rst_n = 1;
        display_state();      // Show initial state after reset
        
        // Cycle through all states by providing pulse signals
        // State 1 (Street 1 Green) to State 2 (Street 1 Yellow)
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 2: Street 1 Yellow
        
        // State 2 to State 3 (Street 2 Green)
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 3: Street 2 Green
        
        // State 3 to State 4 (Street 2 Yellow)
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 4: Street 2 Yellow
        
        // State 4 back to State 1 (Street 1 Green) - complete cycle
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 1: Street 1 Green
        
        // Continue for additional cycle verification
        // State 1 to State 2 again
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 2: Street 1 Yellow
        
        // State 2 to State 3 again
        #10 pulso = 1;        // Assert pulse
        #10 pulso = 0;        // De-assert pulse
        #10 display_state();  // Show State 3: Street 2 Green
        
        // End simulation
        #20 $finish;          // Terminate simulation
    end
    
    // Automatic verification - runs on each clock edge
    always @(posedge clk) begin
        // Safety check 1: Verify that both streets never have green signal simultaneously
        // This would be dangerous for traffic
        if (rua_1_verde && rua_2_verde)
            $error("ERROR: Both streets have GREEN signal!");
            
        // Safety check 2: Verify that signals on Street 1 are mutually exclusive
        // Only one light should be active at a time
        if ((rua_1_verde + rua_1_amarelo + rua_1_vermelho) > 1)
            $error("ERROR: Multiple signals active on Street 1!");
            
        // Safety check 3: Verify that signals on Street 2 are mutually exclusive
        // Only one light should be active at a time
        if ((rua_2_verde + rua_2_amarelo + rua_2_vermelho) > 1)
            $error("ERROR: Multiple signals active on Street 2!");
    end
    
endmodule
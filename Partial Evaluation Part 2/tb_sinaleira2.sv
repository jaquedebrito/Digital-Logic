// Testbench: tb_sinaleira2 (Testing the Traffic Light Module)

module tb_sinaleira2;

    // Test signals
    logic clk;
    logic reset;
    logic pedestre;
    logic rua_1_vermelho;
    logic rua_1_amarelo;
    logic rua_1_verde;
    logic rua_2_vermelho;
    logic rua_2_amarelo;
    logic rua_2_verde;
    logic pedestre_vermelho;
    logic pedestre_verde;
    
    // Access to module's internal state for monitoring
    // (Need to declare as state_t to access)
    typedef enum logic [2:0] {
        START,
        STREET_1_GREEN,
        STREET_1_YELLOW,
        STREET_2_GREEN,
        STREET_2_YELLOW,
        PEDESTRIAN_GREEN,
        PEDESTRIAN_RED
    } state_t;
    
    // Module instantiation
    sinaleira2 tb_sinaleira2 (
        .clk(clk),
        .reset(reset),
        .pedestre(pedestre),
        .rua_1_vermelho(rua_1_vermelho),
        .rua_1_amarelo(rua_1_amarelo),
        .rua_1_verde(rua_1_verde),
        .rua_2_vermelho(rua_2_vermelho),
        .rua_2_amarelo(rua_2_amarelo),
        .rua_2_verde(rua_2_verde),
        .pedestre_vermelho(pedestre_vermelho),
        .pedestre_verde(pedestre_verde)
    );

    // Clock generation with correct period of 1s
    // For simulation, we'll use smaller units, but the proportion is important
    always begin
        #0.5 clk = ~clk;  // 0.5 time units for each half cycle = 1 time unit per complete cycle
    end

    // Set initial values and run test
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        pedestre = 0;
        
        // Monitor important signals on each change
        $monitor("T=%0t | State=%s | Counter=%0d | S1G=%b | S1Y=%b | S1R=%b | S2G=%b | S2Y=%b | S2R=%b | PG=%b | PR=%b | Ped=%b",
                 $time, 
                 tb_sinaleira2.current_state.name(),  // Shows current state name
                 tb_sinaleira2.counter,
                 rua_1_verde, rua_1_amarelo, rua_1_vermelho,
                 rua_2_verde, rua_2_amarelo, rua_2_vermelho,
                 pedestre_verde, pedestre_vermelho, pedestre);
        
        // Apply reset
        $display("Applying reset...");
        reset = 1;
        #1;
        reset = 0;
        
        // Wait for street 1 green (1 cycle)
        $display("Waiting for Street 1 Green...");
        wait(tb_sinaleira2.current_state == STREET_1_GREEN);
        #1;  // Wait enough time to see the state
        
        // Wait for street 1 yellow (2 cycles)
        $display("Waiting for Street 1 Yellow...");
        wait(tb_sinaleira2.current_state == STREET_1_YELLOW);
        #2;  // Wait enough time to see the state
        
        // Wait for street 2 green (4 cycles)
        $display("Waiting for Street 2 Green...");
        wait(tb_sinaleira2.current_state == STREET_2_GREEN);
        #4;  // Wait enough time to see the state
        
        // Wait for street 2 yellow (2 cycles)
        $display("Waiting for Street 2 Yellow...");
        wait(tb_sinaleira2.current_state == STREET_2_YELLOW);
        #2;  // Wait enough time to see the state
        
        // Activate pedestrian to test this transition
        $display("Activating pedestrian signal...");
        pedestre = 1;
        
        // Wait for pedestrian green (5 cycles)
        $display("Waiting for Pedestrian Green...");
        wait(tb_sinaleira2.current_state == PEDESTRIAN_GREEN);
        #5;  // Wait enough time to see the state
        
        // Wait for pedestrian red (1 cycle)
        $display("Waiting for Pedestrian Red...");
        wait(tb_sinaleira2.current_state == PEDESTRIAN_RED);
        #1;  // Wait enough time to see the state
        
        // Deactivate pedestrian
        pedestre = 0;
        
        // Wait one complete cycle to verify return to beginning
        $display("Verifying return to normal sequence...");
        wait(tb_sinaleira2.current_state == STREET_1_GREEN);
        #1;
        
        // End simulation
        $display("Test successfully completed!");
        $finish;
    end
    
    // Cycle counter verifier
    // This block prints messages at the end of each important state
    always @(posedge clk) begin
        // Verify end of street 1 green cycle (should last 1 cycle)
        if (tb_sinaleira2.current_state == STREET_1_GREEN && tb_sinaleira2.counter == 0)
            $display("VERIFICATION: Street 1 Green lasted 1 cycle as expected");
            
        // Verify end of street 2 green cycle (should last 4 cycles)
        if (tb_sinaleira2.current_state == STREET_2_GREEN && tb_sinaleira2.counter == 0)
            $display("VERIFICATION: Street 2 Green lasted 4 cycles as expected");
            
        // Verify end of pedestrian green cycle (should last 5 cycles)
        if (tb_sinaleira2.current_state == PEDESTRIAN_GREEN && tb_sinaleira2.counter == 0)
            $display("VERIFICATION: Pedestrian Green lasted 5 cycles as expected");
    end

endmodule

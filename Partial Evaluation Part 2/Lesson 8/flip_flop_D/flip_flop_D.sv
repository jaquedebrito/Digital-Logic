// Circuito Síncrono 1: Flip-Flop Tipo D com lógica combinacional
module flip_flop_D (
    input logic clk,           // Clock signal
    input logic reset,         // Reset signal (active high)
    input logic [1:0] entrada, // Input signals for combinational logic
    output logic q             // Registered output
);
    // Internal signals
    logic d;  // D input for the flip-flop
    
    // Combinational logic to generate d from inputs and current q value
    // Example logic: d = (entrada[0] & entrada[1]) | (~q & entrada[0])
    always_comb begin
        d = (entrada[0] & entrada[1]) | (~q & entrada[0]);
    end
    
    // Sequential logic (D flip-flop)
    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;  // Reset to 0
        end
        else begin
            q <= d;     // Register the value from combinational logic
        end
    end
endmodule
// Circuito Síncrono 4: Detector de Padrão Serial "0111"
module detec_padrao_serial (
    input logic clk,        // Clock signal
    input logic reset,      // Reset signal (active high)
    input logic x,          // Serial input bit
    output logic match      // Output flag indicating pattern match
);
    
    // 4-bit shift register to store the last 4 bits
    logic [3:0] dado_ff;
    
    // The constant pattern we're looking for
    localparam logic [3:0] VALOR_DESEJADO = 4'b0111;
    
    // Sequential logic to update shift register and check for match
    always_ff @(posedge clk) begin
        if (reset) begin
            // Reset condition
            dado_ff <= 4'b0000;
            match <= 1'b0;
        end
        else begin
            // Shift in the new bit from x (MSB first shift register)
            dado_ff <= {dado_ff[2:0], x};
            
            // Compare the current value in the register with our desired pattern
            match <= ({dado_ff[2:0], x} == VALOR_DESEJADO);
        end
    end
endmodule
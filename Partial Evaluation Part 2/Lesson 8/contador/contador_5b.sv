// Circuito Síncrono 2: Contador de 5 bits
module contador_5b (
    input logic clk,                  // Clock signal
    input logic reset,                // Reset signal (active high)
    input logic [4:0] valor_maximo,   // Maximum count value
    output logic [4:0] contagem,      // Current count
    output logic fim                  // Flag indicating max count reached
);
    
    // Sequential logic for counter
    always_ff @(posedge clk) begin
        if (reset) begin
            contagem <= 5'b00000;     // Reset counter to zero
            fim <= 1'b0;              // Reset end flag
        end
        else begin
            if (contagem == valor_maximo) begin
                contagem <= 5'b00000; // Reset counter when max value is reached
                fim <= 1'b1;          // Set end flag
            end
            else begin
                contagem <= contagem + 1'b1; // Increment counter
                fim <= 1'b0;          // Clear end flag
            end
        end
    end
endmodule
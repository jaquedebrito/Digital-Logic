// Module: sinaleira (Traffic Light Controller)
// Description: Controls traffic lights for a two-street intersection
// Inputs:
//   - clk: System clock signal
//   - rst_n: Active-low reset signal
//   - pulso: Pulse signal to advance to the next state
// Outputs:
//   - rua_1_verde: Street 1 green light
//   - rua_1_amarelo: Street 1 yellow light
//   - rua_1_vermelho: Street 1 red light
//   - rua_2_verde: Street 2 green light
//   - rua_2_amarelo: Street 2 yellow light
//   - rua_2_vermelho: Street 2 red light
module sinaleira (
    input logic clk,
    input logic rst_n,
    input logic pulso,
    output logic rua_1_verde,
    output logic rua_1_amarelo,
    output logic rua_1_vermelho,
    output logic rua_2_verde,
    output logic rua_2_amarelo,
    output logic rua_2_vermelho
);

    // State definition for the finite state machine
    // Uses 2 bits to represent 4 possible states
    typedef enum logic [1:0] {
        RUA1_VERDE = 2'b00,    // State 0: Street 1 Green, Street 2 Red
        RUA1_AMARELO = 2'b01,  // State 1: Street 1 Yellow, Street 2 Red
        RUA2_VERDE = 2'b10,    // State 2: Street 1 Red, Street 2 Green
        RUA2_AMARELO = 2'b11   // State 3: Street 1 Red, Street 2 Yellow
    } state_t;
    
    // Registers for current and next state
    state_t state, next_state;
    
    // Pulse edge detection logic
    logic pulso_reg;           // Register to store previous pulse value
    logic pulso_edge;          // Signal that becomes high only on rising edge of pulse
    
    // Register for edge detection - samples the pulse input on each clock cycle
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pulso_reg <= 1'b0;  // Reset the register to 0
        else
            pulso_reg <= pulso;  // Store current pulse value for next cycle comparison
    end
    
    // Detects rising edge - high when current pulse is 1 and previous sample was 0
    assign pulso_edge = pulso & ~pulso_reg;
    
    // Current state logic - updates the state register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RUA1_VERDE;  // Initial state after reset: Street 1 Green
        else if (pulso_edge)      // Only change state on rising edge of pulse
            state <= next_state;  // Update to the computed next state
    end
    
    // Next state logic - determines the state transition based on current state
    always_comb begin
        case (state)
            RUA1_VERDE:    next_state = RUA1_AMARELO;   // From Street 1 Green to Street 1 Yellow
            RUA1_AMARELO:  next_state = RUA2_VERDE;     // From Street 1 Yellow to Street 2 Green
            RUA2_VERDE:    next_state = RUA2_AMARELO;   // From Street 2 Green to Street 2 Yellow
            RUA2_AMARELO:  next_state = RUA1_VERDE;     // From Street 2 Yellow to Street 1 Green
            default:       next_state = RUA1_VERDE;     // Default case for safety
        endcase
    end
    
    // Output logic - determines the traffic light outputs based on current state
    always_comb begin
        // Default values - all signals off for safety
        rua_1_verde = 1'b0;
        rua_1_amarelo = 1'b0;
        rua_1_vermelho = 1'b0;
        rua_2_verde = 1'b0;
        rua_2_amarelo = 1'b0;
        rua_2_vermelho = 1'b0;
        
        // Set appropriate signals based on current state
        case (state)
            RUA1_VERDE: begin
                rua_1_verde = 1'b1;     // Street 1 Green light ON
                rua_2_vermelho = 1'b1;  // Street 2 Red light ON
            end
            
            RUA1_AMARELO: begin
                rua_1_amarelo = 1'b1;   // Street 1 Yellow light ON
                rua_2_vermelho = 1'b1;  // Street 2 Red light ON
            end
            
            RUA2_VERDE: begin
                rua_1_vermelho = 1'b1;  // Street 1 Red light ON
                rua_2_verde = 1'b1;     // Street 2 Green light ON
            end
            
            RUA2_AMARELO: begin
                rua_1_vermelho = 1'b1;  // Street 1 Red light ON
                rua_2_amarelo = 1'b1;   // Street 2 Yellow light ON
            end
        endcase
    end

endmodule
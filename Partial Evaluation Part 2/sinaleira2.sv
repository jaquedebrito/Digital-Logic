// Module: sinaleira2 (Traffic Light Control System)

module sinaleira2 (
    input logic clk,                // Clock signal
    input logic reset,              // Reset signal to initialize the system
    input logic pedestre,           // Pedestrian request (1 = pedestrian wants to cross, 0 = no request)
    output logic rua_1_vermelho,    // Traffic light for street 1 (Red)
    output logic rua_1_amarelo,     // Traffic light for street 1 (Yellow)
    output logic rua_1_verde,       // Traffic light for street 1 (Green)
    output logic rua_2_vermelho,    // Traffic light for street 2 (Red)
    output logic rua_2_amarelo,     // Traffic light for street 2 (Yellow)
    output logic rua_2_verde,       // Traffic light for street 2 (Green)
    output logic pedestre_vermelho, // Pedestrian light (Red)
    output logic pedestre_verde     // Pedestrian light (Green)
);

    // State machine definitions for controlling the traffic light
    typedef enum logic [2:0] {
        START,                 // Initial state
        STREET_1_GREEN,        // Street 1 Green light
        STREET_1_YELLOW,       // Street 1 Yellow light
        STREET_2_GREEN,        // Street 2 Green light
        STREET_2_YELLOW,       // Street 2 Yellow light
        PEDESTRIAN_GREEN,      // Pedestrian Green light
        PEDESTRIAN_RED         // Pedestrian Red light
    } state_t;

    state_t current_state, next_state;  // Current and next states of the traffic light system

    // Counter for tracking the time for each light
    logic [3:0] counter;

    // Time constants (in cycles) for each state
    parameter X = 0;  // Time for STREET_1_GREEN (0 + current cycle = 1 cycle total)
    parameter Y = 3;  // Time for STREET_2_GREEN (3 + current cycle = 4 cycles total)
    parameter YELLOW_TIME = 1; // Time for Yellow light (2 cycles total)
    parameter PEDESTRIAN_TIME = 4;  // Time for Pedestrian Green (5 cycles total)

    // State update logic, triggered by clock or reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= START;  // Reset to the START state
            counter <= 0;            // Reset the counter
        end else begin
            if (counter > 0) begin
                counter <= counter - 1; // Decrease the counter on each clock cycle
            end else begin
                current_state <= next_state; // Transition to the next state
                // Set counter based on the next state
                case (next_state)
                    STREET_1_GREEN: counter <= X;  // Set counter for street 1 green
                    STREET_1_YELLOW: counter <= YELLOW_TIME;  // Set counter for street 1 yellow
                    STREET_2_GREEN: counter <= Y;  // Set counter for street 2 green
                    STREET_2_YELLOW: counter <= YELLOW_TIME;  // Set counter for street 2 yellow
                    PEDESTRIAN_GREEN: counter <= PEDESTRIAN_TIME;  // Set counter for pedestrian green
                    PEDESTRIAN_RED: counter <= 0;  // Set counter to 0 for pedestrian red (1 cycle total)
                    default: counter <= 0;  // Default case
                endcase
            end
        end
    end

    // Combinational logic for determining the next state and setting signals
    always_comb begin
        // Default signals - all red by default
        rua_1_vermelho = 1;
        rua_1_amarelo = 0;
        rua_1_verde = 0;
        rua_2_vermelho = 1;
        rua_2_amarelo = 0;
        rua_2_verde = 0;
        pedestre_vermelho = 1;
        pedestre_verde = 0;

        // Default state
        next_state = current_state;

        case (current_state)
            START: begin
                next_state = STREET_1_GREEN;  // Initial state transitions to street 1 green
            end

            STREET_1_GREEN: begin
                rua_1_verde = 1;  // Set street 1 green light
                rua_1_vermelho = 0; // Turn off street 1 red light
                rua_2_vermelho = 1; // Keep street 2 red light
                pedestre_vermelho = 1; // Keep pedestrian red light
                
                if (counter == 0) begin
                    next_state = STREET_1_YELLOW;  // Transition to street 1 yellow when counter expires
                end
            end

            STREET_1_YELLOW: begin
                rua_1_amarelo = 1; // Set street 1 yellow light
                rua_1_vermelho = 0; // Turn off street 1 red light
                rua_2_vermelho = 1; // Keep street 2 red light
                pedestre_vermelho = 1; // Keep pedestrian red light
                
                if (counter == 0) begin
                    next_state = STREET_2_GREEN;  // Transition to street 2 green when counter expires
                end
            end

            STREET_2_GREEN: begin
                rua_2_verde = 1;  // Set street 2 green light
                rua_2_vermelho = 0; // Turn off street 2 red light
                rua_1_vermelho = 1; // Keep street 1 red light
                pedestre_vermelho = 1; // Keep pedestrian red light
                
                if (counter == 0) begin
                    next_state = STREET_2_YELLOW;  // Transition to street 2 yellow when counter expires
                end
            end

            STREET_2_YELLOW: begin
                rua_2_amarelo = 1; // Set street 2 yellow light
                rua_2_vermelho = 0; // Turn off street 2 red light
                rua_1_vermelho = 1; // Keep street 1 red light
                pedestre_vermelho = 1; // Keep pedestrian red light
                
                if (counter == 0) begin
                    if (pedestre) begin
                        next_state = PEDESTRIAN_GREEN;  // If pedestrian requested, switch to pedestrian green
                    end else begin
                        next_state = STREET_1_GREEN;  // Otherwise, return to street 1 green
                    end
                end
            end

            PEDESTRIAN_GREEN: begin
                pedestre_verde = 1; // Set pedestrian green light
                pedestre_vermelho = 0; // Turn off pedestrian red light
                rua_1_vermelho = 1; // Keep street 1 red light
                rua_2_vermelho = 1; // Keep street 2 red light
                
                if (counter == 0) begin
                    next_state = PEDESTRIAN_RED;  // Transition to pedestrian red when counter expires
                end
            end

            PEDESTRIAN_RED: begin
                pedestre_vermelho = 1; // Set pedestrian red light
                rua_1_vermelho = 1; // Keep street 1 red light
                rua_2_vermelho = 1; // Keep street 2 red light
                next_state = STREET_1_GREEN;  // Transition back to street 1 green
            end

            default: begin
                next_state = START;  // Default state
            end
        endcase
    end

endmodule

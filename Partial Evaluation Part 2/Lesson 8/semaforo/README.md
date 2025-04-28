Traffic Light Controller with Finite State Machine (FSM)

Author: Jaqueline Ferreira de Brito

Project Description

This project implements a traffic light controller using a synchronous finite state machine (FSM) in SystemVerilog. The system manages transitions between states of a typical traffic light (Red, Green, Yellow), with an additional Start state for initialization.
Specified Requirements
Inputs

    clk: System clock - pulses once per second

    reset: Active-high, resets the system to the "Start" state

    pulse: Active-high, triggers the state transition of the traffic light

Outputs

    red: Signal for the red traffic light

    green: Signal for the green traffic light

    yellow: Signal for the yellow traffic light

State Table
State	Encoding	Outputs	Next State
Start	2'b00	red=1, yellow=1	Automatically transitions to Red
Green	2'b01	green=1, others=0	On pulse, transitions to Yellow
Yellow	2'b10	yellow=1, others=0	On pulse, transitions to Red
Red	2'b11	red=1, others=0	On pulse, transitions to Green

Note: If there is no pulse, the state remains the same.
Implementation

The implementation consists of:

    Finite State Machine (FSM): With 4 states as defined in the table above.

    Pulse Edge Detection: To ensure that each pulse causes only one state transition.

    Output Logic: Defines the correct outputs based on the current state.

    Synchronous Reset: To initialize the system to the Start state.

Enumerated Type for States

typedef enum logic [1:0] {
    START    = 2'b00,
    GREEN    = 2'b01,
    YELLOW   = 2'b10,
    RED      = 2'b11
} state_t;

module traffic_light(
    input  logic clk,      // System clock
    input  logic reset,    // Active-high synchronous reset
    input  logic pulse,    // Signal to advance state
    output logic red,      // Output for red light
    output logic green,    // Output for green light
    output logic yellow    // Output for yellow light
);
    // State definition using enumerated type
    typedef enum logic [1:0] {
        START    = 2'b00,
        GREEN    = 2'b01,
        YELLOW   = 2'b10,
        RED      = 2'b11
    } state_t;
    
    // Registers for current state and pulse edge detection
    state_t state;
    logic pulse_reg;
    logic pulse_edge;
    
    // Edge detection for pulse signal
    always_ff @(posedge clk) begin
        pulse_reg <= pulse;
    end
    
    // pulse_edge is 1 only when pulse transitions from 0 to 1
    assign pulse_edge = pulse & ~pulse_reg;
    
    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= START;
        end
        else begin
            case (state)
                START:   state <= RED;
                GREEN:   if (pulse_edge) state <= YELLOW;
                YELLOW:  if (pulse_edge) state <= RED;
                RED:     if (pulse_edge) state <= GREEN;
                default: state <= RED;
            endcase
        end
    end
    
    // Combinational logic for outputs
    always_comb begin
        // Default values
        red = 1'b0;
        green = 1'b0;
        yellow = 1'b0;
        
        case (state)
            START:   begin red = 1'b1; yellow = 1'b1; end
            GREEN:   green = 1'b1;
            YELLOW:  yellow = 1'b1;
            RED:     red = 1'b1;
        endcase
    end
endmodule

Simulation Results

The simulation verified the correct operation of the traffic light controller:
Initialization and Reset

    Active Reset (Time=0-5): State = START, red=1, yellow=1

    Automatic transition to RED (Time=25): red=1, green=0, yellow=0

Full Cycle of States

    RED → GREEN

        Pulse detected at Time=30

        State changes to GREEN: red=0, green=1, yellow=0

    GREEN → YELLOW

        Pulse detected at Time=60

        State changes to YELLOW: red=0, green=0, yellow=1

    YELLOW → RED

        Pulse detected at Time=110

        State changes to RED: red=1, green=0, yellow=0

    RED → GREEN (new cycle)

        Pulse detected at Time=140

        State changes to GREEN: red=0, green=1, yellow=0

Behavior with Reset During Operation

    Reset activated during GREEN state (Time=160)

        System returns to START state: red=1, yellow=1

        After releasing reset, transitions to RED

Pulse Edge Detection

    The pulse_edge signal detects only the 0→1 transition of the pulse signal.

    This prevents multiple state transitions when the pulse remains high.

    Example: Time=30-40, even if the pulse remains high, pulse_edge=1 occurs only once.

Technical Improvement: Pulse Edge Detection

The implementation includes a pulse edge detection mechanism, which was not explicitly required by the specification. This addition is an important technical improvement because it:

    Ensures that each 0→1 transition of the pulse signal causes exactly one state change.

    Prevents undefined behavior if the pulse signal stays high for multiple cycles.

    Provides a more deterministic and controllable behavior for the system.

Conclusion

The traffic light controller was successfully implemented, demonstrating all required functionalities:

    States are encoded as specified (2 bits).

    Outputs correspond to each state as described in the table.

    State transitions are controlled by the pulse signal.

    Reset functionality works, returning the system to the START state and then to RED.

    The system remains in the current state when no pulse is detected.

The addition of pulse edge detection represents an improvement that makes the system more robust and predictable. The circuit exhibited consistent and reliable behavior in all tests.

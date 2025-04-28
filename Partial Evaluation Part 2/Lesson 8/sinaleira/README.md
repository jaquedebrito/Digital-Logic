Traffic Light Controller For Two-Street Intersection

Author: Jaqueline de Brito

Project Overview

This project implements a traffic light controller for a two-street intersection using a finite state machine approach in SystemVerilog. The controller manages the traffic signals for both streets, ensuring proper sequencing and safety conditions are maintained.
Project Requirements

    Design a circuit to control traffic lights at an intersection (Street 1 and Street 2)
    Implementation should use a state machine approach
    The system should advance to the next state on a pulse input signal
    The system should output the following signals:
        Street 1: Green, Yellow, and Red lights
        Street 2: Green, Yellow, and Red lights
    Define initial state (one street begins with green light)
    Determine the necessary number of states and their encoding
    Create a state transition table
    Calculate the number of bits required for state encoding
    Implement the design and testbench
    Verify the correct behavior of the controller

State Analysis
Number of States Required

The traffic light controller requires 4 states to properly manage the intersection:

    Street 1 Green, Street 2 Red
    Street 1 Yellow, Street 2 Red
    Street 1 Red, Street 2 Green
    Street 1 Red, Street 2 Yellow

State Encoding

With 4 states required, we need 2 bits for state encoding:

    State 1 (RUA1_VERDE): 00
    State 2 (RUA1_AMARELO): 01
    State 3 (RUA2_VERDE): 10
    State 4 (RUA2_AMARELO): 11

State Transition Table
Current State	Encoding	Next State	Street 1 Lights	Street 2 Lights
RUA1_VERDE	00	RUA1_AMARELO	Green: ON, Yellow: OFF, Red: OFF	Green: OFF, Yellow: OFF, Red: ON
RUA1_AMARELO	01	RUA2_VERDE	Green: OFF, Yellow: ON, Red: OFF	Green: OFF, Yellow: OFF, Red: ON
RUA2_VERDE	10	RUA2_AMARELO	Green: OFF, Yellow: OFF, Red: ON	Green: ON, Yellow: OFF, Red: OFF
RUA2_AMARELO	11	RUA1_VERDE	Green: OFF, Yellow: OFF, Red: ON	Green: OFF, Yellow: ON, Red: OFF
Implementation Details
Design Features

    Pulse-driven state transitions: State changes occur only on the rising edge of the pulse input
    Edge detection: Implemented to ensure accurate detection of pulse signals
    Safety checks: Ensures mutually exclusive signals on each street
    Initial state: Street 1 Green, Street 2 Red after reset
    Modular design: Clear separation of state logic and output logic

Module Interface
SystemVerilog

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

Verification
Testbench Features

    Clock generation: Creates a stable clock signal for testing
    Reset verification: Tests proper initialization of the system
    Complete cycle testing: Verifies all state transitions
    Safety assertion: Automatically checks for unsafe conditions:
        Both streets should never have green light simultaneously
        Each street should have only one active light at a time
    State display: Shows current state of all traffic lights after each transition

Simulation Results
Code

Time=10: Street 1 [G=1, Y=0, R=0] | Street 2 [G=0, Y=0, R=1]
Time=40: Street 1 [G=0, Y=1, R=0] | Street 2 [G=0, Y=0, R=1]
Time=70: Street 1 [G=0, Y=0, R=1] | Street 2 [G=1, Y=0, R=0]
Time=100: Street 1 [G=0, Y=0, R=1] | Street 2 [G=0, Y=1, R=0]
Time=130: Street 1 [G=1, Y=0, R=0] | Street 2 [G=0, Y=0, R=1]
Time=160: Street 1 [G=0, Y=1, R=0] | Street 2 [G=0, Y=0, R=1]
Time=190: Street 1 [G=0, Y=0, R=1] | Street 2 [G=1, Y=0, R=0]
Simulation complete via $finish(1) at time 210 NS + 0

The simulation results confirm that:

    The controller properly transitions through all states
    Traffic lights correctly show the appropriate signals at each state
    The system completes a full cycle and returns to the initial state
    No safety violations occurred during testing

Conclusion

The implemented traffic light controller successfully meets all requirements. It properly manages traffic flow at a two-street intersection by sequencing through green, yellow, and red lights for both streets in a safe manner. The controller advances states based on an external pulse input, making it versatile for various timing scenarios.

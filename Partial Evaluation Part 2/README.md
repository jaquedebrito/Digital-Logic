Traffic Light Controller

Project Overview

This repository contains a SystemVerilog implementation of a traffic light controller for an intersection with two streets and a pedestrian crossing. The controller manages signal transitions according to specific timing requirements and safety constraints.

Traffic Light Controller
Project Specifications

    Controller Name: sinaleira2

    Timing Parameters: Based on student ID
        Street 1 GREEN light duration: X seconds
        Street 2 GREEN light duration: Y seconds (4 seconds in this implementation)
        YELLOW light duration: 2 seconds for all transitions
        Pedestrian GREEN light duration: 5 seconds after request

    Input Signals:
        clk: System clock with 1 Hz frequency
        reset: Active high, returns state to "Start"
        pedestre: 1-bit pedestrian crossing request

    Output Signals:
        Traffic lights for Street 1 and Street 2 (RED, YELLOW, GREEN)
        Pedestrian signals (RED, GREEN)

    Safety Constraints:
        Vehicle signals must transition through YELLOW before switching from GREEN to RED
        Only one GREEN light can be active at any time
        Multiple RED lights can be active simultaneously

Original Implementation Issues

The initial implementation had several timing issues as identified by the professor:

    Incorrect Timing Parameters:
        Street 2 GREEN duration was 5 cycles instead of the required 4
        Street 1 GREEN duration was not correctly set to 1 cycle
        Pedestrian GREEN duration was 6 seconds instead of the required 5

    Signal Logic Problems:
        RED lights remained on when GREEN or YELLOW lights were active for the same street

    Clock Frequency:
        The testbench did not implement the clock with the specified 1 Hz frequency

Implementation Details
Interface
SystemVerilog

module sinaleira2 (
    input logic clk,
    input logic reset,
    input logic pedestre,
    output logic rua_1_vermelho,
    output logic rua_1_amarelo,
    output logic rua_1_verde,
    output logic rua_2_vermelho,
    output logic rua_2_amarelo,
    output logic rua_2_verde,
    output logic pedestre_vermelho,
    output logic pedestre_verde
);

Initial Issues and Corrections
1. Timing Problems

Before:

    Street 1 GREEN lasted longer than 1 cycle
    Street 2 GREEN lasted 5 cycles instead of the required 4
    Pedestrian GREEN lasted 6 cycles instead of the required 5
    Timing parameters were not properly calculated

After:

    Corrected the timing parameters:
    SystemVerilog

    parameter X = 0;               // For Street 1 GREEN (1 cycle total with current cycle)
    parameter Y = 3;               // For Street 2 GREEN (4 cycles total with current cycle)
    parameter YELLOW_TIME = 1;     // For YELLOW states (2 cycles total with current cycle)
    parameter PEDESTRIAN_TIME = 4; // For Pedestrian GREEN (5 cycles total with current cycle)

2. Signal Logic Issue

Before:

    RED signals remained ON even when GREEN or YELLOW was active for the same street
    This created conflicting signals and unclear visual indicators

After:

    Modified the signal logic to ensure RED signals turn OFF when GREEN or YELLOW is active:
    SystemVerilog

    STREET_1_GREEN: begin
        rua_1_verde = 1;
        rua_1_vermelho = 0; // Turn off RED when GREEN is active
        // ...
    end

3. Testbench Issues

Before:

    Testbench used fixed time delays that didn't properly synchronize with the state machine
    Clock period wasn't properly set to 1 second
    Output monitoring didn't provide adequate verification of timing requirements

After:

    Created a synchronized testbench that waits for state transitions:
    SystemVerilog

wait(tb_sinaleira2.current_state == STREET_1_GREEN);

Added verification messages to confirm correct timing:
SystemVerilog

    $display("VERIFICATION: Street 1 Green lasted 1 cycle as expected");

    Improved signal monitoring to track all relevant outputs and internal state

Final Implementation

The final implementation includes:

    A finite state machine with 7 states:
        START
        STREET_1_GREEN
        STREET_1_YELLOW
        STREET_2_GREEN
        STREET_2_YELLOW
        PEDESTRIAN_GREEN
        PEDESTRIAN_RED

    Counter-based timing system that ensures each state lasts for the required duration

    Proper signal management that prevents conflicting signals and ensures safety

    Pedestrian request handling that activates the pedestrian crossing at appropriate times

Simulation Results

The corrected implementation was successfully validated with a testbench that confirmed:
Code

VERIFICATION: Street 1 Green lasted 1 cycle as expected
VERIFICATION: Street 2 Green lasted 4 cycles as expected
VERIFICATION: Pedestrian Green lasted 5 cycles as expected

These results confirm that all timing requirements were met and the traffic light controller operates as specified.
Conclusion

The traffic light controller now correctly implements all the requirements:

    ✓ Proper interface declarations
    ✓ Complete state machine implementation
    ✓ Correct timing for all signals
    ✓ Appropriate output generation
    ✓ Functional testbench with valid verification

The initial issues identified by the professor have been addressed, and the system now operates with correct timing and signal behavior.

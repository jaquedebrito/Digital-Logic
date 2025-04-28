5-bit Counter – Implementation and Analysis

Author: Jaqueline Ferreira de Brito

Project Description

This project implements a configurable 5-bit synchronous counter in SystemVerilog, which increments with each clock cycle up to a maximum value defined by an input, restarting at zero after reaching that value.
Specified Requirements
Inputs

    clk: System clock – the counter increments at every cycle

    reset: Active high, resets the counter to zero

    max_value: 5 bits – maximum value before the counter resets to zero

Outputs

    count: 5 bits – current counter value

    done: Indicates (high level) that the counter has reached the value specified in max_value

Implementation

The implementation consists of a 5-bit synchronous counter with the following characteristics:

    Synchronous Increment: The counter increments at every rising edge of the clock

    Synchronous Reset: When reset=1, the counter resets to zero at the next clock edge

    Configurable Maximum Value: The counter can be set to count up to any value between 0 and 31

    Automatic Restart: Upon reaching the maximum value, the counter automatically resets to zero

    End of Count Detection: The 'done' signal is activated for one cycle when the counter completes a counting cycle



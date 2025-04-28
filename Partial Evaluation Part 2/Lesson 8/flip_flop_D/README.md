D-Type Flip-Flop with Combinational Logic

Author: Jaqueline Ferreira de Brito

Overview

This project implements a D-type flip-flop with dedicated combinational logic to determine the input value (D) dynamically based on external inputs and the current state of the output (Q). The design is written in SystemVerilog, emphasizing the clear separation between combinational and sequential logic in synchronous digital systems.
Objectives

    Utilize a single clock signal for synchronization.

    Implement a D flip-flop triggered by the rising edge of the clock.

    Generate the D input combinationally using:

        Two external inputs (input[1:0]).

        The current output value (q) of the flip-flop.

    Maintain a clear separation between combinational and sequential logic blocks.

System Architecture
1. Sequential Logic

    A D flip-flop captures the input (d) at the rising edge of the clock signal.

2. Combinational Logic

    Determines the next state (d) based on:

        Two external signals (input[1:0]).

        The current output (q).

The combinational expression implemented is:

d = (input[0] & input[1]) | (~q & input[0]);

Functional Analysis

The simulation validated the circuit behavior across different input combinations:
Reset Behavior

    When reset = 1, the output q is forced to 0 on the next rising clock edge.

    Example:
    Time 60–65: reset = 1 → q = 0

Input Behavior
Input	Current q	Computation of d	Next q	Remarks
00	0	0 | 0 = 0	0	Stable
00	1	0 | 0 = 0	0	Stable
01	0	0 | 1 = 1	1	Toggle
01	1	0 | 0 = 0	0	Reset
10	0	0 | 0 = 0	0	Stable
10	1	0 | 0 = 0	0	Stable
11	0	1 | 1 = 1	1	Set
11	1	1 | 0 = 1	1	Hold

Detailed Behavior

    Input = 01:

        If q = 0: d = 1 → q toggles to 1.

        If q = 1: d = 0 → q resets to 0.

    Input = 10:

        Regardless of q, d = 0 → q becomes or remains 0.

    Input = 11:

        Regardless of q, d = 1 → q becomes or remains 1.

    Input = 00:

        q remains at 0, ensuring a stable state.

Conclusion

The D-type flip-flop with embedded combinational logic was successfully implemented and verified through simulation. The design satisfies all the specified functional requirements and exhibits behavior that aligns perfectly with the intended logic.

    Clear separation between combinational and sequential logic was maintained.

    Correct behavior was observed for all input conditions.

    Reset functionality performed as expected.

This project showcases best practices in synchronous digital circuit design, emphasizing modularity, clarity, and correctness — critical qualities for larger and more complex systems.

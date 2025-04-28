Serial Pattern Detector "0111"

Author: Jaqueline Ferreira de Brito

Project Overview

This project implements a serial pattern detector in SystemVerilog designed to identify the occurrence of the specific sequence "0111" within a continuous bit stream. The architecture is based on a 4-bit shift register combined with continuous comparison logic to detect the target pattern.
Requirements
Inputs

    clk: System clock signal (1 Hz).

    reset: Active-high synchronous reset, responsible for clearing the shift register.

    x: Serial bit input, shifted in one bit per clock cycle.

Outputs

    match: High when the sequence "0111" is detected within the last 4 stored bits.

Implementation Structure

The detector was built using the following functional blocks:

    Shift Register
    Stores the last four received input bits.

    Reference Value
    Fixed pattern "0111" used for comparison.

    Comparison Logic
    Combinational circuit that checks if the register matches the target pattern.

    Synchronous Reset
    Resets the shift register to "0000" when triggered.

The complete source code is available in the repository.
Results Analysis

Simulation results verified the correct operation of the pattern detector, covering the following aspects:
1. Accurate Detection of the "0111" Pattern

    Test 1: Input sequence 0→1→1→1 was correctly detected (match = 1).

    Test 5: After applying a reset, the new occurrence of the sequence was also detected with match = 1.

2. Rejection of Incorrect Patterns

    Test 2: Pattern "1111" was correctly not detected (match = 0).

    Test 3: Various invalid sequences maintained match = 0.

3. Reset Functionality

    Test 4: The reset correctly cleared the shift register, allowing normal operation to resume after release.

Behavior Example Table
Time (ns)	Reset	x	dado_ff	match	Observation
15	0	0	0000	0	Initial state after reset
35	0	1	0000	0	First bit received
45	0	1	0001	0	Second bit received
55	0	1	0011	0	Third bit received
65	0	1	0111	1	Pattern detected!
75	0	0	1111	0	Pattern lost
185	0	1	0111	1	Pattern detected again!
Conclusion

The Serial Pattern Detector "0111" was successfully implemented, demonstrating the following capabilities:

    Accurate detection of the "0111" sequence within a serial bit stream.

    Proper maintenance of the detection state while the pattern persists.

    Continuous operation after reset events.

    High reliability and simplicity, utilizing only a shift register and comparison logic.

This solution showcases an efficient and lightweight design, ideal for basic serial pattern recognition applications in digital systems.

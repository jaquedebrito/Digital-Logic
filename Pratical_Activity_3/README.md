Vote Counter Project
Overview

This project implements a vote counter circuit using SystemVerilog. The circuit counts the number of active bits (high/1 value) in a 3-bit input and generates a corresponding 4-bit one-hot encoded output where only one bit is active, indicating the count.
Project Requirements

The original requirements were to:

    Create a hierarchical design called conta_votos (later translated to vote_counter)
    Implement the module with 3-bit input vector and 4-bit output vector
    The output should be a one-hot encoded value indicating the number of high bits in the input
    Use logic gates from the provided library in a hierarchical structure

Implementation Details
Interface

    Input: V[2:0] - 3-bit input vector
    Output: R[3:0] - 4-bit one-hot encoded output

One-Hot Encoding Behavior

    R[0] = 1 when no bits in V are high
    R[1] = 1 when exactly one bit in V is high
    R[2] = 1 when exactly two bits in V are high
    R[3] = 1 when all three bits in V are high

Logic Structure

The implementation uses basic logic cells from the standard library:

    INVX1HVT: Inverters to generate complemented inputs
    AND3X1HVT: 3-input AND gates to detect specific bit patterns
    OR3X1HVT: 3-input OR gates to combine multiple conditions

Design Approach

The circuit was designed using a structured approach:

    Create inverted versions of all inputs
    Use AND gates to detect specific bit combinations for each output case
    Combine the relevant conditions using OR gates for outputs R[1] and R[2]
    Map the final results to the appropriate output bits

Simulation Results

The design was thoroughly tested using a testbench that systematically verifies all possible input combinations:
Input (V)	Output (R)	Meaning
000	0001	0 bits high
001	0010	1 bit high
010	0010	1 bit high
011	0100	2 bits high
100	0010	1 bit high
101	0100	2 bits high
110	0100	2 bits high
111	1000	3 bits high

These results confirm that the circuit correctly implements the one-hot encoding of the bit count as required.
Development Process

The project went through several iterations:

    Initial implementation with minor issues:
        Incorrect module name (contador_votos instead of conta_votos)
        Missing wire declarations for some intermediate signals

    Corrected version with fixed module name and complete signal declarations

    Final English version with renamed module (vote_counter) and comprehensive comments for clarity and documentation

Files

    vote_counter.sv - The main module implementing the vote counting logic
    vote_counter_tb.sv - The testbench that verifies all input combinations

Conclusion

The vote counter project successfully implements a digital circuit that counts high bits in an input vector and represents this count using one-hot encoding. The design meets all specified requirements and has been thoroughly verified through simulation.

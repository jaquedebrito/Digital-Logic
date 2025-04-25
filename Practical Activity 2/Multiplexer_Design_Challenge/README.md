8x1 Multiplexer Implementation
Project Overview

This project implements an 8x1 multiplexer using basic logic gates in a hierarchical structure. The implementation follows a structural design approach in SystemVerilog, where the circuit is built by instantiating and connecting standard library cells.
Requirements

The assignment required the development of an 8x1 multiplexer with the following specifications:

    Module name: meu_primeiro_mux8x1 (my_first_mux8x1)

    Interface:
        EN: Enable input (active high) - when low, output is forced to 0
        A[3:0]: Address/selector input - determines which input is connected to the output
        X[7:0]: Data inputs - one of these will be selected based on the address
        Q: Output - carries the selected input bit when enabled

    Design Constraints:
        Use only basic logic gates from the provided library
        Implement in a hierarchical structure
        Verify functionality through simulation

Implementation
Design Approach

The multiplexer was implemented using a combination of:

    Inverters (INVX1HVT)
    3-input AND gates (AND3X1HVT)
    2-input AND gates (AND2X1HVT)
    2-input OR gates (OR2X1HVT)

The design follows a four-stage process:

    Address Decoding: Converting the 3-bit address into eight select lines
    Input Selection: ANDing each input with its corresponding select line
    Output Combining: ORing all selected inputs together
    Enable Control: ANDing the combined output with the enable signal

Key Components

    Address Decoder: Converts the 3-bit address (A[2:0]) into eight one-hot select lines
    Input Selectors: Eight AND gates that pass the input bit only when its address is selected
    OR Tree: A structure of OR gates that combines all selected inputs
    Enable Gate: Final AND gate that controls whether the output is active or forced to 0
Verification

The design was tested using a comprehensive testbench that verified:

    Enable Functionality: Ensuring Q=0 when EN=0, regardless of A and X values
    Address Selection: Verifying that each address selects the correct input bit
    Random Testing: Testing with random values to ensure consistent behavior

Key Test Cases

    Test 1: Verify that output is forced to 0 when the enable signal is low
    Test 2: Verify all possible selection combinations with a pattern of alternating 1s and 0s
    Test 3: Test with random input values to ensure correct selection in all cases

Debug Process

During development, an issue was identified where certain address values weren't correctly selecting the corresponding input. This was caused by an incorrect ordering of parameters in the AND gates that connected the inputs with their select signals. The issue was resolved by correcting the parameter order.
Simulation Results

The simulation verified that the multiplexer functions correctly:

    When EN=0: Output Q is consistently 0
    When EN=1: Output Q mirrors the bit from X selected by address A[2:0]

All test cases passed successfully, confirming the correct implementation of the 8x1 multiplexer according to specifications.
Technical Details

    Design tool: Xcelium
    Design language: SystemVerilog
    Implementation method: Gate-level structural design
    Target library: Standard cell library with basic logic gates (INVX1HVT, AND2X1HVT, AND3X1HVT, OR2X1HVT)

Conclusion

This project successfully implemented an 8x1 multiplexer using basic logic gates in a hierarchical structure. The design meets all the specified requirements and has been thoroughly verified through simulation. The hierarchical approach demonstrates how complex digital circuits can be built from simple logic elements, providing a foundation for understanding digital design principles.

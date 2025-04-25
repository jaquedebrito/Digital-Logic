Describe in SystemVerilog a synthesizable bus arbiter.

Your design must use only synthesizable structures (design named "arbitro") and instantiate this block in the testbench (module named "tb").

Your design has the following inputs and outputs:

    Inputs: req[3:0] -> 4 bits

    Outputs: grant[3:0], available, and grant_num[1:0] -> 4 bits, 1 bit, and 2 bits, respectively.

Expected Behavior:

    A device requests access to the bus by setting its req bit ("request") to a logic high. If no device requests access, available should be high.

    You may choose a priority policy among the devices.

    Only one output in grant should be high at any time, granting bus access to the respective device that requested it.

    The grant_num output should display the binary-encoded number of the device granted access. For example: if grant is b0100, then grant_num should be d2.

Deliverables for submission on Moodle:

    A screenshot of the simulation demonstrating correct functionality.

    The design file.

    The testbench file (.sv) containing the stimulus generation.

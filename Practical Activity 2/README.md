Comparator with Constant

Practical Task:
Build the design using logic gates from the library (in a hierarchical manner! Tip: cat fast_vdd1v0_basicCells_hvt.lib | grep "function\|cell ")

You must create a hierarchical block (the module must be named sistema_x) that instantiates the required cells (this is your design!), and instantiate this block in the testbench (module named tb).
Design Specification:

    Input X[3:0] → 4-bit input

    Output Q → 1-bit output

Expected Behavior:

    The output Q should be logic high if and only if X == 4'b0101

    Otherwise, Q should be logic low

📌 Deliverables on Moodle:

    A testbench file (.sv) containing the stimulus generation

    A design file for sistema_x showing the logic gate implementation

    A screenshot of the simulation waveform proving the correct functionality

🌟 Bonus (optional):

Implement a second module named sistema_y, which has an additional input B, used instead of the constant 4'b0101 in the comparison.
Expected behavior: output Q is logic high if A == B

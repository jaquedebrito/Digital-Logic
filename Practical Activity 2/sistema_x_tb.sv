// Testbench for sistema_x module
`timescale 1ns/10ps

module sistema_x_tb();

    // Declare input registers and output wire
    reg A, B, C, D;     // Input bits
    wire Q_s;           // Output wire connected to module output

    // Generate input stimuli
    initial begin
        // Loop through all possible 4-bit combinations (from 0 to 15)
        for (int i = 0; i < 16; i++) begin
            {A, B, C, D} = i; // Assign bits to inputs A, B, C, D
            #5;              // Wait 5 time units between each stimulus
        end
        $finish; // End simulation
    end

    // Instantiate the module under test (sistema_x)
    sistema_x sv(.X({A, B, C, D}), .Q(Q_s));

    // Display header and monitor signal values
    initial begin
        $display("        Time   A B C D   Q");
        $display("        =====  =========  ==");
        $monitor($time, "   %b %b %b %b   %b", A, B, C, D, Q_s);
    end

endmodule

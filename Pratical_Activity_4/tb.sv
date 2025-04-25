// -----------------------------------------------------------------------------
// Module: tb (Testbench for arbitro)
// Description: Testbench to verify the behavior of the synthesizable bus arbiter.
//
// Functionality:
// - Instantiates the "arbitro" module.
// - Generates all possible combinations of 4-bit request signals (req[3:0]).
// - Monitors and displays the outputs: grant[3:0], available, and grant_num[1:0].
// - Displays results in a formatted output table for simulation analysis.
//
// Task Requirement:
// - Part of the individual assignment for validating the SystemVerilog arbiter design.
// - Simulation results must be captured via screenshot and submitted alongside this file.
//
// Author: Jaqueline Ferreira de Brito
// -----------------------------------------------------------------------------

module tb;

    // Declare testbench signals
    logic [3:0] req;         // 4-bit input vector simulating request lines
    logic [3:0] grant;       // 4-bit output vector from the arbiter
    logic available;         // Output indicating if the bus is available (no active requests)
    logic [1:0] grant_num;   // Encoded output indicating which request was granted

    // Instantiate the DUT (Device Under Test): the arbitro module
    arbitro ab_tb(
        .req(req),
        .grant(grant),
        .available(available),
        .grant_num(grant_num)
    );

    // Initial block to drive stimuli and monitor outputs
    initial begin

        // Print table headers to the console
        $display("req  |  grant  |  available  |  grant_num");
        $display("==== |  =====  |  =========  |  =========");

        // Continuously display changes to signals as simulation runs
        $monitor("%b   %b        %b         %d", req, grant, available, grant_num);

        // Apply all possible request combinations (from 0000 to 1111)
        for (int i = 0; i < 16; i++) begin
            req = i;     // Assign binary value to req (simulate different requests)
            #5;          // Wait 5 time units before changing the request
        end

        // End simulation
        $finish;
    end

endmodule


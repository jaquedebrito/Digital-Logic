// -----------------------------------------------------------------------------
// Module: arbitro
// Description: Synthesizable bus arbiter written in SystemVerilog for individual task.
// 
// Functionality:
// - Handles 4 request lines (req[3:0]) from devices seeking access to a shared bus.
// - Grants access to only one device at a time using a fixed-priority policy (lowest index wins).
// - Output grant[3:0] indicates which device has been granted access.
// - Output available is high when no requests are active.
// - Output grant_num[1:0] is the binary-encoded number of the granted device.
//
// Design Constraints:
// - Only synthesizable constructs are used.
// - The arbiter module is to be instantiated in a separate testbench module (tb).
//
// Task Requirement:
// - Individual assignment for synthesis-ready SystemVerilog code.
// - Must include simulation waveform screenshot and both design and testbench files.
//
// Author: Jaqueline Ferreira de Brito
// -----------------------------------------------------------------------------

module arbitro(
    input  logic [3:0] req,        // 4-bit input vector representing requests from 4 sources
    output logic [3:0] grant,      // 4-bit output vector indicating which source is granted
    output logic available,        // Output signal that is high when no request is active
    output logic [1:0] grant_num   // Encoded 2-bit output showing which request is granted
);

    // If no request is active (all bits are 0), 'available' is set to 1 (true)
    assign available = (req == 4'b0000);  

    // Combinational logic to determine which request is granted
    always_comb begin
        grant = 4'b0000;        // Default: no grant
        grant_num = 2'b00;      // Default: no valid grant number

        if (req != 4'b0000) begin // Check if there is at least one active request

            // Priority encoder: grant access to the first (lowest index) active request
            if (req[0]) begin
                grant = 4'b0001;      // Grant to source 0
                grant_num = 2'b00;    // Grant number 0
            end
            else if (req[1]) begin
                grant = 4'b0010;      // Grant to source 1
                grant_num = 2'b01;    // Grant number 1
            end
            else if (req[2]) begin
                grant = 4'b0100;      // Grant to source 2
                grant_num = 2'b10;    // Grant number 2
            end
            else if (req[3]) begin
                grant = 4'b1000;      // Grant to source 3
                grant_num = 2'b11;    // Grant number 3
            end
        end
    end
endmodule


//JAQUELINE FERREIRA DE BRITO
//CLASS ACTIVITY - VOTE COUNTER TESTBENCH
//This testbench verifies the vote_counter module by testing all possible
//input combinations and displaying the results in a formatted table

`timescale 1ns/10ps

module vote_counter_tb();
	
	// Test signals declaration
	reg [2:0] V;   // Input vector - 3-bit stimulus
	wire [3:0] R;  // Output vector - 4-bit one-hot encoded result
	
	// Test sequence - iterate through all possible input combinations (000 to 111)
	initial
	begin
		integer i;
		for(i = 0; i < 8; i = i + 1 ) 
		begin
		    V = i[2:0];  // Set input to current test vector
		    #10;         // Wait 10ns between test cases
		end
		#10 $finish;     // End simulation after all test cases
	end
	
	// Instantiate the Device Under Test (DUT)
	vote_counter vc (.V(V), .R(R));

	// Display setup for monitoring results
	initial
	begin
		// Table header
		$display("                   Time Input Output");
		$display("                   ---- ----- ------");		
		// Monitoring format - displays time, input vector, and output vector
		$monitor("  At time %t, V = %b, R = %b", $time, V, R);
	end

endmodule
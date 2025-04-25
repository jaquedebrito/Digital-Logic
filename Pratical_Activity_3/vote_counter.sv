//JAQUELINE FERREIRA DE BRITO
//CLASS ACTIVITY - VOTE COUNTER
//This module counts the number of high bits in a 3-bit input vector
//and represents the count using a one-hot encoded 4-bit output

`timescale 1ns/10ps

module vote_counter (input [2:0] V, output [3:0] R);
	
	// Inverted input signals
	wire ev2, ev1, ev0;
	// Intermediate signals for R[1] calculation
	wire sr3, sr2, sr1, sr0;
	// Intermediate signals for R[2] calculation
	wire r3, r2, r1, r0;

	//Inverters to generate complemented inputs 
	INVX1HVT IN_1 (ev0, V[0]);  // ev0 = NOT V[0]
	INVX1HVT IN_2 (ev1, V[1]);  // ev1 = NOT V[1]
	INVX1HVT IN_3 (ev2, V[2]);  // ev2 = NOT V[2]
  
	// R[0] - Active when no input bits are high (count = 0)
	// R[0] = NOT V[2] AND NOT V[1] AND NOT V[0]
	AND3X1HVT AN_0 (R[0], ev2, ev1, ev0);

	// R[1] - Active when exactly one input bit is high (count = 1)
	// Case 1: Only V[0] is high
	AND3X1HVT AN1_1 (sr1, ev2, ev1, V[0]);  
	// Case 2: Only V[1] is high
	AND3X1HVT AN1_2 (sr2, ev2, V[1], ev0);  
	// Case 3: Only V[2] is high
	AND3X1HVT AN1_3 (sr3, V[2], ev1, ev0);  
	// R[1] = ANY of the three cases above
	OR3X1HVT OR_1 (R[1], sr1, sr2, sr3);

	// R[2] - Active when exactly two input bits are high (count = 2)
	// Case 1: V[1] and V[0] are high, V[2] is low
	AND3X1HVT AN2_1 (r1, ev2, V[1], V[0]);  
	// Case 2: V[2] and V[0] are high, V[1] is low
	AND3X1HVT AN2_2 (r2, V[2], ev1, V[0]); 
	// Case 3: V[2] and V[1] are high, V[0] is low
	AND3X1HVT AN2_3 (r3, V[2], V[1], ev0);  
	// R[2] = ANY of the three cases above
	OR3X1HVT OR_2 (R[2], r1, r2, r3);

	// R[3] - Active when all three input bits are high (count = 3)
	// R[3] = V[2] AND V[1] AND V[0]
	AND3X1HVT AN3_1 (R[3], V[2], V[1], V[0]);
	
endmodule
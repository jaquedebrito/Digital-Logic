
module comp_endereco(
	
	input [7:0] A, 		// endereco ligado ao pino
	output reg [7:0] A_01, 	// endereço se nível alto ou baixo
	output reg [7:0] A_F   	// endereço se FLOAT
	);
	integer i;
	always_comb
	begin
		for(i=0; i<8; i=i+1)
		begin
			if(A[i]===1'bz)
			begin
				A_01[i]=1'bx;
				A_F[i] =1'b1;
			end
			else
			begin
				A_01[i]=A[i];
				A_F[i] =1'b0;
			end
		end
	end

endmodule
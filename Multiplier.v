module multiplier(input[2:0]A, input[3:0]B, output[6:0]C );

wire [7:0]Carry;

	assign C[0] = B[0] & A[0];
	assign {Carry0 , C[1]} = (B[1] & A[0]) + (B[0] & A[1]);
	assign{Carry1,Carry2,C[2] }= (B[2] & A[0]) + (B[1] & A[1]) + (B[0] & A[2]) + Carry0;
	assign{Carry3,Carry4, C[3] }= (B[3] & A[0]) + (B[2] & A[1]) + (B[1] & A[2]) + {Carry1,Carry2} ;
	assign {Carry5,Carry6,C[4]} = (B[3] & A[1] ) + (B[2] & A[2])+ {Carry3,Carry4};	
	assign {Carry7,C[5]} = (B[3] & A[2]) + {Carry5,Carry6};
	assign C[6] = Carry7;

endmodule 

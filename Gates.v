module gates(	input A,B,
		output [6:0]X );

assign X[0] =   A & B;
assign X[1] = ~(A & B);
assign X[2] =   A | B;
assign X[3] = ~(A | B);
assign X[4] =   A ^ B;
assign X[5] = ~(A ^ B);
assign X[6] = ~(A);

endmodule 

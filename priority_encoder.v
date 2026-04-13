module priority_encoder(input [3:0]D,
			output [1:0]X);

always @(*)
begin
	if	(D[3])
		X = 2'b11;
	
	else if (D[2])
		X = 2'b10;

	else if (D[2])
		X = 2'b01;

	else if (D[2])
		X = 2'b00;

	else 
		X = 2'b00;

end
endmodule 

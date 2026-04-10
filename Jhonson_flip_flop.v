module jhonson_flip_flop(input clk , rst ,
			 input[7:0]D,
			 output reg [7:0]Q);

	always@ (posedge clk)
	if (~rst)
	begin
		Q <= 0;
	end
	else
	begin
		Q <= { ~Q[0] , Q[7:1] };
	end
endmodule

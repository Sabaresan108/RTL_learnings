module latch( input D,clk,
	      output reg Q );

always@(clk)
	begin
		if(clk)
		begin
			Q <= D;
		end
	end
endmodule

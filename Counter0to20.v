module counter_0_20(input clk,rst,
		    output reg [4:0] A,
		    output reg X);

always @(posedge clk)
begin
	if(~rst)
	begin
		A <= 0;
	end
	else
	begin
		case({A[3],A[2],A[1]})
			3'b000 : X <= 0; 
			3'b001 : X <= 0;
			3'b010 : X <= 0;
			3'b011 : X <= 1;
			3'b100 : X <= 0;
			3'b101 : X <= 1;
			3'b110 : X <= 1;
			3'b111 : X <= 1;
		endcase
	
			A <= A + 1;

	end
end	
endmodule 

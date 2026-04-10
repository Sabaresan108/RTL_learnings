module ring_counter(input clk , rst , 
	input [3:0] D,
	output reg [3:0]q);

always@(posedge clk)
begin
	if(~rst)
	begin
		q <= 0;
	end
	else
	begin
		q <= { q[0] , q[3:1] };
	end
end
endmodule


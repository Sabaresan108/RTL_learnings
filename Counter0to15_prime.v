module counter_prime(input clk,rst,
		     output reg [3:0] count,
		     output reg X);

always@ (posedge clk)
begin
	if(~rst)
	begin
		count <= 0;
	end
	else
	begin
		case (count)
			4'd0  : X <= 0;
			4'd1  : X <= 0;
			4'd2  : X <= 1;		
			4'd3  : X <= 1;	
			4'd4  : X <= 0;
			4'd5  : X <= 1;
			4'd6  : X <= 0;
			4'd7  : X <= 1;
			4'd8  : X <= 0;
			4'd9  : X <= 0;
			4'd10 : X <= 0;
			4'd11 : X <= 1;	
			4'd12 : X <= 0;
			4'd13 : X <= 1;
			4'd14 : X <= 0;
			4'd15 : X <= 0;
		endcase
	
		count <= count + 1;

	end
end	
endmodule 

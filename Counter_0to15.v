module counter0to15(input clk,rst,
		     output reg [3:0] count);


always@ (posedge clk)
begin
	if(~rst)
	begin
		count <= 0;
	end

	else
	begin
		if (count == 4'd15)
		begin
			count <= 4'd7;
		end
		else
			count <= count + 1;

	end
end
endmodule 

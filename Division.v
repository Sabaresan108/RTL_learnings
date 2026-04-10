module divisiontest (input clk,rst,
			output reg q);


reg [1:0]counter;
always@(posedge clk)
begin
	if(rst)
		counter <=0;

	else if (counter == 2'b11)
	begin
		q <= 1;
		counter <= 0;
	end
	else
		counter <= counter + 1;
end

endmodule

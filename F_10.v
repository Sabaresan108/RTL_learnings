module F_10(input clk , rst, 
		output q);

reg [2:0] counter;
reg clk2;

always@(posedge clk)
begin
	if (rst)
	begin
		counter <= 3'b111;
		clk2 <=0;
	end
	else
	begin
		if(counter == 3'b100)
		begin
			clk2 <= ~ clk2;
			counter <= 0;
		end
		else 
			counter <= counter+1;
	end	
end
assign q = clk2;
endmodule		

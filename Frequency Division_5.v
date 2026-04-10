module F_5(input clk , rst, 
		output q);

reg [2:0] counter;
reg evencount;
reg clk2;

always@(posedge clk , negedge clk)
begin
	if(rst)
	begin
		counter <= 3'b111;
		evencount <=0;
		clk2 <= 0;
	end
	else 
	begin
		if(counter == 3'b100)
		begin
			if(~evencount)
				clk2 <=1;
			else 
				clk2 <=0;
			counter <=0;
			evencount <= ~evencount;
		end
		else
		begin
			counter <= counter + 1;
		end
	end
end
assign q = clk2;
endmodule
				

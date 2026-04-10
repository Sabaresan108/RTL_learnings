module f_2(input clk , rst, 
	   output q);

reg counter;
reg clk2;

always@(posedge clk)
begin
	if(rst)
	begin
		counter <=0;
		clk2 <=0;
	end
	else
	begin

		clk2 <= ~counter; 
		counter <= counter + 1;
	end
end
assign q = clk2;

endmodule

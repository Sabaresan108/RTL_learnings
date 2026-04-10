module F_4(input clk , rst, 
	   output q);

reg [1:0]counter;
reg clk2;

always@(posedge clk)
begin
	if(rst)
	begin
		counter <=2'b11;
		clk2 <=0;
	end
	else
	begin
		if(counter == 2'b01)
		begin
			clk2 <= ~clk2;
			counter <= 0; 
		end
		else
		counter <= counter + 1;
	end
end
assign q = clk2;
endmodule

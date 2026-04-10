module F_3(input clk , rst,
	output  q);

reg [1:0] counter;
reg [1:0] counter_delay;
reg evencount;
reg clk2;

always@(posedge clk , negedge clk)
begin
	if(rst)
	begin
		counter <= 2'b11;
		evencount <=0;
		clk2 <= 0;
		counter_delay <= 0;
	end
	else 
	begin
			if(counter == 2'b10)
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
				

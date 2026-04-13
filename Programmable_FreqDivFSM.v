module Programmable_FreqDivFSM (input clk , rst , 
				input [1:0] freq_divisor ,
				output q );
reg [1:0]freq_divisor_delay;
reg reset;
always@(posedge clk)
begin
	if(rst)
		reset <=0;
	else
	begin
		freq_divisor_delay <= freq_divisor;
		if (freq_divisor_delay != freq_divisor)
			reset <= 1;
		else
			reset <= 0;
	end
end
wire reset_combined = reset | rst;

wire clk2 , clk3 , clk4 , clk5, clk10;
f_2  uut0 (clk , reset_combined , clk2);
F_3  uut1 (clk , reset_combined , clk3);
F_4  uut2 (clk , reset_combined , clk4);
F_5  uut3 (clk , reset_combined , clk5);

assign q = freq_divisor[1]? (freq_divisor[0]? clk5 : clk4) : freq_divisor[0]? clk3 : clk2 ;

endmodule
		

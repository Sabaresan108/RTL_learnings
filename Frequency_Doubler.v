module Freq_Doubler ( input clk , rst , clk_delay , clk_delay4 , clk_delay8,
		      output q , q1 ,q2);


assign q = clk ^ clk_delay;
assign q1 = q ^ clk_delay4;
assign q2 = q1 ^ clk_delay8;

endmodule

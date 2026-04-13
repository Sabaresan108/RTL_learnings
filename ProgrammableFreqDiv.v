module ProgrammableFreqDiv ( input clk_com , rst_com , 
			     input [1:0]freq_divisor,
			     output q );


wire clk2 , clk3 , clk4 , clk5, clk10;
f_2  uut0 (clk_com , rst_com , clk2);
F_3  uut1 (clk_com , rst_com , clk3);
F_4  uut2 (clk_com , rst_com , clk4);
F_5  uut3 (clk_com , rst_com , clk5);


assign q = freq_divisor[1]? (freq_divisor[0]?   clk5: clk4) : freq_divisor[0]? clk3 : clk2 ;

endmodule 

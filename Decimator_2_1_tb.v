module Decimator_2_1_tb;
reg clk , rst , start, en,Ld;
reg[15:0] Data ;
wire[31:0] Combined_result ;

Decimator2_1 uut (clk , rst , start , en , Ld , Data , Combined_result);

initial begin clk = 0; end
always #5 clk = ~clk;
initial begin
	rst = 1;
	#10;
	Data = 15'h0005;
	rst = 0; 
	en = 1;
	#10;
	Data = 15'h0005;
	#10;
	Ld = 1;
	Data = 15'h0004;
	#10;
	Data = 15'h0004;
end
endmodule
	

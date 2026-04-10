`timescale 1ps/1ps
module D_flipflop_tb ();
reg D , clk;
wire Q;

D_flipflop uut ( D , clk , Q);
initial
begin
clk = 0;
end

always #10 clk = ~clk;

initial 
begin
	D = 1;
	#25;
	D = 0;
	#10;
	D = 1;
	#20;
	D = 0;
end
endmodule

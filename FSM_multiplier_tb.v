`timescale 1ns/1ps
module FSM_multiplier_tb;
reg [7:0]MultiC,MultiP;
reg clk , rst , start;
wire [17:0] PR;

FSM_multiplier uut ( clk, rst, start, MultiC, MultiP, PR);

initial
begin
	clk = 1; 
end

always #10 clk = ~clk; 

initial
begin

rst = 0;
MultiC = 8'b00000000;
MultiP = 8'b10000101;
#10
rst=1;
start = 1;
#60
start=0;

$finish;
end
endmodule

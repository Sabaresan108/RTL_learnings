`timescale 1ns/1ps
module FSM_8_16_tb;

reg [2:0] MultiP,MultiC;
reg clk, rst, start;
wire [5:0] PR;
	
FSM_8_16 uut (clk, rst, start, MultiP, MultiC, PR);

initial
begin
	clk = 1; 
end

always #10 clk = ~clk; 

initial
begin

rst = 0;
#10
rst = 1;
start = 1;
MultiC = 3'b101;
MultiP = 3'b100;
#60
start=0;

$finish;
end
endmodule

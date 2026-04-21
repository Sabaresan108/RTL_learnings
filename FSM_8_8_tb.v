`timescale 1ns/1ps
module FSM_8_8_tb;
reg [15:0] in1 , in2;
reg clk , rst , start;
wire [15:0] result;

FSM_8_8 uut ( clk , rst , start , in1 , in2 , result);

initial 
begin 
	clk = 1; 
end

always
#10 clk = ~clk;

initial 
begin

rst=0;
#10;
rst =1;
start = 1;
in1 = 16'b1000_0000_0000_0100;
in2 = 16'b0000_1111_1111_1111;
#60;

start =0;
$finish;
end

endmodule

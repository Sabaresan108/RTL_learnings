`timescale 1ns/1ps
module FSM_simple_tb;
reg  x, y, F, E;
reg clk, rst;

FSM_simple uut (clk, rst, x, y, F, E);

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
x = 1;
#15
x = 0;
#15
y = 1;
#15
y = 0;
#15
F = 1;
#15
F = 0;
#15
E = 1;
#15
E = 1;

$finish;
end
endmodule

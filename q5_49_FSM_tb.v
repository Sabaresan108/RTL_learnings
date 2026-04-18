`timescale 1ns/1ps
module q5_49_FSM_tb;

reg clk, rst, x;
wire Y;

q549_FSM uut (clk, rst, x, Y);

initial
begin
clk = 0;
end

always #5 clk = ~clk;

initial 
begin
rst = 0;
x =0;
#15;
rst = 1;
@(posedge clk)
x = 0;
@(posedge clk)
x = 1;
@(posedge clk)
x = 0;
@(posedge clk)
x = 1;
@(posedge clk)
x = 1;
@(posedge clk)
x = 0;
@(posedge clk)
x = 1;
$finish;
end
endmodule 

`timescale 1ns/1ps
module FSM_10110_tb;

reg clk , rst , x;
wire Y;

FSM_10110 uut (clk , rst , x , Y);

initial 
begin
clk = 0;
end

always #5 clk = ~clk;

initial 
begin
rst = 0;
#15;
rst = 1;
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
end
endmodule

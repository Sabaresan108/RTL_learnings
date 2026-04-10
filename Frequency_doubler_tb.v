`timescale 1ns/1ps
module Freq_Doubler_tb;
reg clk , rst;
wire clk_delay , clk_delay4 , clk_delay8;
reg [1:0] multiplier;
wire q , q1 , q2;
wire Multiplied_clock;
//Freq_Doubler uut ( clk , rst , clk_delay , clk_delay4 , clk_delay8 , q , q1,q2);
FreqMul_Programmable uut (clk, clk_delay , clk_delay4 , clk_delay8, multiplier , q,q1,q2 ,Multiplied_clock);

initial begin
clk = 0;
end
assign #5 clk_delay = clk;
always #10 clk = ~clk;

assign #2.5 clk_delay4 = q;
assign #1.25 clk_delay8 = q1;
initial begin
multiplier = 2'b00;
#100;
multiplier = 2'b01;
#100;
multiplier = 2'b10;
end

endmodule

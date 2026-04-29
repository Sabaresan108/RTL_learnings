`timescale 1ns/1ps
module FSM_multiseq_tb;

reg [7:0] Data;
reg clk, rst, En, Ld;
wire [15:0] R0;

FSM_multiseq uut (clk, rst, En, Ld, Data, R0);

initial
begin
	clk = 1;
end

always #10 clk = ~clk;

initial
begin

rst = 0;
En  = 0;
Ld  = 0;
Data = 8'b11110100;

#10
rst = 1;
En = 1;
Ld = 1;
#60

$finish;
end
endmodule

`timescale 1ns/1ps
module FSM_Moore_tb;

reg clk, rst, X_in;
wire Y_out;

FSM_Moore uut (clk, rst, X_in, Y_in);

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
X_in = 1;
@(posedge clk)
X_in = 1;
@(posedge clk)
X_in = 1;
@(posedge clk)
X_in = 1;

$finish;

end
endmodule

`timescale 1ns/1ps
module fifo_16_tb;

reg clk , rst , wr_en , rd_en ,Data;
wire X;
wire full , empty;

fifo_16 uut ( clk , rst , wr_en , rd_en , Data , full , empty ,X );

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
wr_en = 1; Data = 0;
#15;
wr_en = 1; Data = 1;
#15;
wr_en = 1; Data = 1;
#15;
rd_en = 0 ; wr_en = 1;
#45;
rd_en = 0;
#100;
rd_en = 1; wr_en =0;
end
endmodule 

`timescale 1ns/1ps
module FIFO_Buffer_tb;

reg clk , rst , wr_en , rd_en;
reg [7:0] data_in;
wire [7:0]data_out;
wire full , empty;

FIFO_Buffer uut ( clk , rst , wr_en , rd_en , data_in , data_out , full , empty );

initial begin
clk = 0;
end

always #5 clk = ~clk ;

initial begin
rst = 1;
#10;
rst = 0;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1100_0001; #10;
wr_en = 1; data_in = 8'b1010_0001; #10;
wr_en = 1; data_in = 8'b1001_0001; #10;
wr_en = 1; data_in = 8'b1000_1001; #10;
wr_en = 1; data_in = 8'b1000_0101; #10;

wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;

wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;
wr_en = 1; data_in = 8'b1000_0001; #10;

wr_en = 0;
rd_en = 1; #150; //5 cycles of read

rd_en = 0 ;
end
endmodule

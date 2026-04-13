`timescale 1ns/1ps
module UART_TXRX_tb;
reg clk , rst , start_tx,start_rx;
reg [7:0]datain_tx;
wire [7:0]dataout_rx;
wire stop_rx;

UART_TXRX uut ( clk , rst , start_tx ,start_rx, datain_tx , dataout_rx , stop_rx);

initial begin
clk = 1;
end

always #10 clk = ~clk;

initial begin
rst = 1;
start_rx = 1;
datain_tx = 8'b10101011;
start_tx = 0;
#10;
rst = 0 ;
start_tx = 1;
start_rx = 0;
#20;
start_tx = 0;
end

endmodule

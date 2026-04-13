`timescale 1ns/1ps
module UART_TX_tb ;
reg clk , rst , start;
reg [7:0] data_in;
wire [7:0] data_out;
wire stop;

UART_TX uut ( clk , rst , start , data_in , data_out , stop );

initial begin 
clk = 1;
end

always #10 clk = ~clk;

initial begin
data_in  = 8'b10101010;
rst = 1;
start = 0;
#10;
rst = 0 ;
start = 1;
#20;
start = 0;

end
endmodule

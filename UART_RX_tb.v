`timescale 1ns/1ps
module UART_RX_tb;
reg clk, rst  ;
reg data_in;
wire [7:0] data_out;
wire stop ;


UART_RX uut ( clk , rst , data_in , data_out , stop  );

initial begin
clk= 1;
end

always #10 clk = ~clk;

initial begin
rst = 1;  data_in = 1;
#10;
rst = 0;
data_in = 0;
#20;
data_in = 1; #20;
data_in = 0; #20;
data_in = 1; #20;
data_in = 0; #20;
data_in = 1; #20;
data_in = 0; #20;
data_in = 1; #20;
data_in = 0; #20;
data_in = 1; #20;
data_in = 1; #20;
rst = 1;#20;
rst=0; data_in = 0; #20; // next round
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 1; #20;
data_in = 0; #20;

end
endmodule

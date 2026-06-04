
module UART_TXRX(input clk,rst,rx_start,
                 output tx_out,
                 output [3:0] LED);

wire [7:0] rx_data;
wire tx_start;
wire rx_done;
wire tx_led; 
wire [3:0]led_1;


assign tx_start = rx_done ? 1: 0 ;

UART_TX Sending     (clk , rst , tx_start , rx_data ,  tx_out, led_1);

UART_RX Receiving   (clk , rst ,rx_start , rx_data , LED  ,rx_done);

ila_0 uut (clk , rx_start ,  rx_done , rx_data);

endmodule

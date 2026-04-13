module UART_TXRX (input clk , rst , start_tx , start_rx,
		  input [7:0] datain_tx,
		  output [7:0] dataout_rx,
		  output stop_rx);

wire dataout_tx , stop_tx;
wire datain_rx;

UART_TX sending   (clk , rst , start_tx ,datain_tx , dataout_tx , stop_tx);

UART_RX receiving (clk , rst , dataout_tx , dataout_rx ,stop_rx);

//assign datain_rx = start_rx? 0 : dataout_tx;
endmodule

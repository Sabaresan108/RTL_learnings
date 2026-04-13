module UART_TX( input clk , rst , start,
		input [7:0] data_in,
		output reg data_out,
		output reg stop );

parameter 
	  IDLE  =  2'b00,
	  START =  2'b01,
	  STOP  =  2'b10;	
reg [1:0] state , next_state;
reg tx;
reg ready;
reg [3:0] data_counter;
reg [7:0] input_data;

always@(posedge clk)
begin
	if(rst)
	begin
		state <= IDLE;
		data_counter <= 0;
		input_data <= data_in;
	end
	else
		state <= next_state;
end

always@(*)
begin
	tx = 0;
	ready = 0;
	stop = 0;
	case(state)
		IDLE:begin
			if(start)
			begin
				ready = 1;
				next_state = START;
			end
			else
				next_state = IDLE;
		     end

		START:begin
			if(~data_counter[3])
			begin
				tx = 1;
				next_state = START;
			end
			else
			begin
				tx = 0;
				next_state = STOP;
			end
		     end
		STOP:begin
			stop = 1;
			next_state = IDLE;
		     end
	endcase
end

always@(posedge clk)
begin
	if(ready)
		data_out <= 0;
	else if(tx)
	begin
		if(~data_counter[3])
		begin
			data_out <= input_data[0];
			input_data <= input_data >> 1;
			data_counter <= data_counter + 1;
		end
		else
		begin
			data_counter <=0;
			tx <=0;
		end
	end
	else 
		data_out <= 1;

end
endmodule
	

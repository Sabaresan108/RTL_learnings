module UART_RX (	input clk , rst , //start ,
		input data_in ,
		output [7:0] data_out,
		output reg stop  );

parameter	IDLE   = 2'b00,
	 	START  = 2'b01,
		STOP   = 2'b10;

reg [1:0] state , next_state ;
reg [3:0] data_counter;
reg [7:0] rx_reg;
reg tx;


always@(posedge clk)
begin
	if(rst)
	begin
		state        <= IDLE ;
		data_counter <= 0;
		rx_reg       <= 0;
		
	end
	else
		state <= next_state;
end

always@(*)
begin
	stop  = 1;
	tx    = 0;
	case(state)
			IDLE:begin
				if(~data_in)//start)
				begin
					next_state = START;
				end
				else
				begin
					next_state = IDLE;
				end
			     end	
	
			START:begin
				if(data_counter[3])
				begin

					next_state = STOP;

				end
				else
				begin
					tx = 1;
					next_state = START;
				end
			      end	
			STOP:begin
				stop = 0;
				next_state = IDLE;
			     end
	endcase
end
always@(posedge clk)
begin
	if(tx)
	begin
		if(~data_counter[3] )
		begin
			rx_reg       <= {data_in , rx_reg[7:1]};
			data_counter <= data_counter + 1;	
		end
		else 
		begin
			data_counter <=0;
			tx = 0;
		end
	end
end			
	
assign data_out = rx_reg;
endmodule 

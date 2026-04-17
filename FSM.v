module FSM (	input clk , rst , x ,
		output Y);

parameter 
	S0 = 2'b00,
	S1 = 2'b01,
	S2 = 2'b10,
	S3 = 2'b11; 

reg [1:0]state , next_state;
always@(posedge clk)//CLOCKED BLOCK
begin
	if(~rst)
	begin
		state <= S0;
	end
	else
	begin	
		state <= next_state;
	end
end

always@(*)
begin
	next_state = state;
	case(state)
		S0: 
		begin
			if(x == 1)
			begin
				next_state = S1;
			end
		end
		
		S1:
		begin
			if(x==0)
			begin
				next_state = S2;
			end
		end
		
		S2:
		begin
			if(x == 1)
			begin
				next_state = S3;
			end
			
			else
			begin	
				next_state = S0;
			end
		end

		S3:
		begin
			if(x == 1)
			begin
				next_state = S1;
			end
			else
			begin	
				next_state = S0;
			end
		end
endcase
end

assign Y = (state == S3)? 1:0;
endmodule

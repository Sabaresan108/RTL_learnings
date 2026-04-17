
module FSM_10110(input clk , rst , x ,
		 output Y);

parameter 
	S0 = 3'b000,
	S1 = 3'b001,
	S2 = 3'b010,
	S3 = 3'b011,
	S4 = 3'b100,
	S5 = 3'b101;

reg [2:0]state , next_state;
always@(posedge clk)
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
			if(x == 0)
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
				next_state = S4;
			end

			else 
			begin
				next_state = S2;
			end

		end

		S4 :
		begin
			if (x == 0)
			begin
				next_state = S5;
			end

			else 
			begin
				next_state = S1;
			end
			
		end 

		S5:
		begin
			if (x == 1)
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

assign Y = (state == S5 )? 0:1 ;

endmodule 

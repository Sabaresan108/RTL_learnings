module FSM_simple (input clk, rst, x, y, F, E);

reg [2:0] state,next_state;

parameter
	S0 = 3'b000,
	S1 = 3'b001,
	S2 = 3'b010,
	S3 = 3'b011,
	S4 = 3'b100,
	S5 = 3'b101,
	S6 = 3'b110,
	S7 = 3'b111;
	
always@ (posedge clk)
begin
	if (~rst)
	begin
		state <= S0;
	end

	else 
	begin
		next_state <= state;
	end
end

always@ (*)
begin
	case (state)
	
		S0 :
		begin
			if (x)
			begin
				next_state = S1;
			end

			else if (y)
			begin
				next_state = S0;
			end
			
			else
			begin
				next_state = S2;
			end
		end
	
		S1 :
		begin
				next_state = S2;
		end
	
		S2 :
		begin
			if (F)
			begin
				next_state = S3;
			end

			else
			begin
				next_state = S4;
			end
		end

		S3 :
		begin
				next_state = S0;
		end
	
		S4 :
		begin
			if (E)
			begin
				next_state = S5;
			end

			else
			begin
				next_state = S6;
			end
		end
		
		S5 :
		begin
				next_state = S0;
		end	
		
		S6 :
		begin
				next_state = S7;
		end
		S7 :
		begin	
				next_state = S0;
		end
	endcase
end
endmodule 

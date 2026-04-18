module q549_FSM (input clk , rst , x ,
		 output Y);

parameter
	A = 2'b00,
	B = 2'b01,
	C = 2'b10,
	D = 2'b11;

reg [1:0] state,next_state;

always@(posedge clk)
begin
	if (~rst)
	begin
		state <= A;
	end

	else
	begin
		state <= next_state;
	end
end

always@(*)
begin
	next_state = state;
	case (state)
		
		A:
		begin 
			if (x == 0)
			begin 
				next_state = B; 
			end 

			else 
			begin 
				next_state = C; 
			end
		end

		B:
		begin 
			if (x == 0)
			begin 
				next_state = C; 
			end 

			else 
			begin 
				next_state = D; 
			end
		end

		C:
		begin 
			if (x == 1)
			begin 
				next_state = D; 
			end 

			else 
			begin 
				next_state = B; 
			end
		end

		D:
		begin 
			if (x == 1)
			begin 
				next_state = A; 
			end 

			else 
			begin 
				next_state = C; 
			end
		end
	endcase
end

assign Y = (state == D)? 0:1 ;

endmodule 

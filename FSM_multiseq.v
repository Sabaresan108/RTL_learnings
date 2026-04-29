module FSM_multiseq (input clk, rst, En, Ld,
		     input [7:0] Data,
 		     output reg [15:0] R0);

reg [7:0] P0 ,P1;
reg [1:0] state, next_state;
reg loadregs, addregs, enregs;

parameter
	S_idle	= 2'b00,
	S_1	= 2'b01,
	S_full	= 2'b10,
	S_wait	= 2'b11;

always@ (posedge clk)
begin
	if (~rst)
	begin
		state <= S_idle;
	end

	else
	begin
		state <= next_state;
	end
end

always@ (*)
begin
	case (state)
	
		S_idle :
		begin
			if (En)
			begin
				loadregs   =   1;
				next_state = S_1;
			end
	
			else 
			begin
				enregs	   =	  1;
				next_state = S_idle;
			end
		end

		S_1 :
		begin
			loadregs   = 	  1;
			next_state = S_full;
		end
	
		S_full :
		begin
			if (Ld)
			begin
				loadregs   =   1;
				next_state = S_1;
			end

			else
			begin
				next_state = S_wait;
			end
		end

		S_wait :
		begin
			if (Ld)
			begin
				addregs = 1;

				if (En)
				begin
					loadregs   =   1;
					next_state = S_1;
				end
	
				else
				begin
					enregs	   =	  1;
					next_state = S_idle;
				end
			end
		end
	endcase
end	
			
always@ (posedge clk)
begin
	if (loadregs)
	begin
		P1 <= Data;
		P0 <= 	P1;
	end
	
	if (addregs)
	begin
		R0 <= {P1,P0};
	end

	if (enregs)		
	begin
		{P1,P0} <= 0;
	end
end	
endmodule 

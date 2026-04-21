module FSM_multiplier (input clk, rst, start,
		       input [7:0]MultiC,MultiP,
		       output [17:0] PR);

reg loadRegs,addRegs,shiftRegs,decrP;
reg [1:0]state,next_state;
reg [7:0] A ,B , Q;
reg [5:0] P;
reg C;

parameter
	IDLE  = 2'd0,
 	LOAD  = 2'd1,
	ADD   = 2'd2,
	SHIFT = 2'd3;

assign PR = {C , A , Q};

always @ (posedge clk)
begin
	if (~rst)
	begin
		state <= IDLE;
	end
	
	else
	begin
		state <= next_state;
	end
end

always@ (*)
begin
	addRegs   = 0;
	loadRegs  = 0;
	shiftRegs = 0;
	decrP =0;

	case (state)
	
		IDLE :
		begin
			if (start)
			begin
				loadRegs   = 1;
				next_state = LOAD;
			end
		end
		
		LOAD :
		begin	
			decrP = 1;

			if (Q[0] == 1)
			begin
				next_state 	= ADD;
				addRegs 	= 1;
			end
			
			else 
			begin
				next_state 	= SHIFT;
				shiftRegs 	= 1;		
			end
		end
		
		ADD :
		begin
				next_state	= SHIFT;
				shiftRegs 	= 1;
		end

		SHIFT :
		begin
			if (P == 0)
			begin
				next_state	= IDLE;
			end
			
			else
			begin
				next_state	= LOAD;
			end
		end

	endcase
end

always@ (posedge clk)
begin
	if (~rst)
	begin
		A  <=	0;
		C  <=	0;
		B  <= 	MultiC;
		Q  <= 	MultiP;
		P  <=	4'd8;
	end

	
	if (addRegs)		
	begin
		{C, A} <= A + B;
	end

	if (shiftRegs)
	begin
		{C, A, Q} <= {C, A, Q} >> 1;
	end

		if (decrP)
	begin
		P <= P - 1;
	end
end
endmodule
		

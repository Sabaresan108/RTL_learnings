module FSM_multiplier (input clk, rst, start,
		       input [7:0]MultiC,MultiP,
		       output reg [17:0] PR);

reg loadRegs,addRegs,shiftRegs;
reg [1:0]state,next_state;
reg [7:0] A ,B , Q;
reg [5:0] P;
reg C;

parameter
	IDLE  = 2'd0,
 	LOAD  = 2'd1,
	ADD   = 2'd2,
	SHIFT = 2'd3;

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
			if (shiftRegs)
			begin
				next_state = SHIFT;
			end
			
			else
			begin
				next_state = ADD;
				
			end
		end
	endcase
end

always@ (posedge clk)
begin
	if (~rst)
	begin
		A <= 0;
		B <= 0;
		Q <= 0;
		C <= 0;
		P <= 0;
		PR <= 0;
    end

	else
	begin
		A <= 0;
		C <= 0;
		B <= MultiC;
		Q <= MultiP;
		P <= 8; 
	end
	
	if (addRegs)		
	begin
		{C, A} <= A + B;
	end

	if (shiftRegs)
	begin
		{C, A, Q} <= {C, A, Q} >> 1;
		P <= P - 1;
	end
end
endmodule
		

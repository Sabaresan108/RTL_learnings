module Decimator2_1 (input clk , rst , start, en,Ld,
		     input [15:0] Data ,
		     output [31:0] Combined_result);

parameter	S_Idle = 2'b00,
		S_1    = 2'b01,
		S_Full = 2'b10,
		S_Wait = 2'b11;

reg [1:0]state , next_state;
reg [15:0] P1 , P0;
reg [31:0] R0;
reg loadData , loadReg;
reg loadCombined;
reg clearRegs;

always @(posedge clk)
begin
	if(rst)
		state <= S_Idle;
	else
		state <= next_state;
end

always@(*)
begin
	next_state = S_Idle;
	loadReg      = 0;
	loadData     = 0;
	loadCombined = 0;
	clearRegs    = 0;
	case(state)
		S_Idle: begin
				if(rst & ~en)
				begin
					next_state = S_Idle;
					clearRegs  = 0;
				end
				else if(~rst & en)
				begin
					loadData = 1;
					next_state = S_1;
				end
			end
	
		S_1:    begin
				loadReg = 1;
				next_state = S_Full;
		        end
		S_Full: begin
				if(Ld)
				begin
					loadCombined = 1;
					if(en)
						next_state = S_1;
					else
					begin
						clearRegs = 1;
						next_state = S_Idle;
					end
				end
				else
				begin
					next_state = S_Wait;
				end
			end
		S_Wait: begin
				if(Ld)
				begin
					loadCombined = 1;
					if(en)
						next_state = S_1;
					else
					begin
						clearRegs = 1;
						next_state = S_Idle;
					end
				end
				else
					next_state = S_Wait;
			end
	endcase
end

always@(posedge clk)
begin
	if(loadData)
		{P0 , P1} <= {Data , P0};
	if(loadReg)
		{P0 , P1} <= {Data , P0};
	if(clearRegs)
		{P0 , P1} <= {16'b0,16'b0};
	if(loadCombined)
	 	 R0       <= {P1 , P0};
end

assign Combined_result = R0;
endmodule
		

	
					
	

				
			

		

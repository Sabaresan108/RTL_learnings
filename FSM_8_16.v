module FSM_8_16(input clk, rst, start,
	input [2:0]MultiP,MultiC,
	output reg[5:0] PR );

reg [2:0] AR, BR;
reg state, next_state;
reg loadRegs,add;

parameter
	IDLE = 1'b0,
	ADD  = 1'b1;

always@(posedge clk)
begin
	if (~rst)
	begin
		state <= IDLE;
		PR <= 0;
		AR <= 0;
		BR <= 0;
	end
	else
	begin
		state <= next_state;
	end
end

always @(*)
begin
	add = 0;
	loadRegs =0;
	
	case (state)

			
		IDLE : 
		begin
			if (start) 
			begin
				loadRegs = 1;
				next_state = ADD;
	                end
		end
		
		ADD :
		begin
			if(AR == 0)
			begin
				next_state = IDLE;
			end
			
			else
			begin 		
				add = 1;
			end
		end
	endcase
end 

always@(posedge clk)
begin
	if(loadRegs)
	begin
		AR <= 	MultiP;
		BR <=	MultiC;
	end
	
	if(add)
	begin
		AR 	<= AR - 1;
		PR	<= BR + PR;
	end
end
endmodule    

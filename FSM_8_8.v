module FSM_8_8(input clk , rst, start,
		input [15:0] data1 ,data2 ,
		output reg[15:0]  CR);

parameter
	IDLE = 1'b0,
	LOADREGS = 1'b1;

reg state, next_state;
reg [15:0] AR , BR;
always @(posedge clk)
begin
	if(~rst)
	begin
		AR 	<= 0;
		BR	<= 0;
		CR	<= 0;
		state 	<= IDLE;
	end
	else
	begin
		state	<= next_state;
	end
end

always @(*)
begin
	case (state)
	
		IDLE:
		begin
			if(start)
			begin
				AR = data1;
				BR = data2;
				next_state = LOADREGS;
			end
		end
		LOADREGS:
		begin
			if(AR[15] == 1)//MSB
 			begin
				CR = {AR[15],AR[15:1]};
			end
			else if (AR[15] == 0)
			begin
				if(AR == 0)
				begin
					CR = 0;
				end
				else
				begin
					CR = BR << 1;
				end
			end
			next_state = IDLE;
		end
	endcase
end
endmodule

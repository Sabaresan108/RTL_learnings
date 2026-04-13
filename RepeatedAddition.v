module RepeatedAddition (input clk , rst , start,
			 input [4:0] Multiplicand , Multiplier ,
			 output [9:0] Product);

reg state , next_state;
reg [4:0] AR , BR;
reg [9:0] PR;
reg loadReg ,addReg;
wire zero;

parameter IDLE = 1'b0,
	  ADD  = 1'b1;
	  
always@(posedge clk)
begin
	if(rst)
		state <= IDLE;
	else
		state <= next_state;
end

always@(*)
begin
	loadReg = 0;
	addReg = 0;
	next_state = IDLE;
	case(state)
		IDLE:begin
			if(start)
				begin
				next_state = ADD;
				loadReg = 1;
				end
		     end
		ADD:begin
			if(zero)
				next_state = IDLE;
			else
				begin
				addReg = 1;
				next_state = ADD;
				end
		    end
	endcase
end

always@(posedge clk)
begin
	if(loadReg)
	begin
		AR <= Multiplier ;
		BR <= Multiplicand;
		PR <= 0;
	end
	
	if(addReg)
	begin
		PR <= PR + BR;
		AR <= AR - 1;
	end
end

assign zero = (AR == 0);
assign Product = PR ;
endmodule
			

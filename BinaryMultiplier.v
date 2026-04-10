module BinaryMultiplier(input clk , rst , start,
			input [3:0] Multiplier , Multiplicand ,
			input [2:0] size,
			output [7:0] Product);

reg [1:0] state , next_state;
reg loadRegs , shiftRegs , addRegs;
reg [3:0] A , B , Q ;
reg [2:0]P;
reg C;
wire zero;

parameter S_Idle = 2'b00,
	  S_Loaded = 2'b01,
	  S_Sum = 2'b10,
	  S_Shifted = 2'b11;

always@(posedge clk)
begin 
	if(rst)
		state <= S_Idle;
	else
		state <= next_state;
end

always@(*)
begin
	loadRegs = 0;
	shiftRegs = 0;
	addRegs = 0;

	next_state = S_Idle;

	case(state)
		S_Idle: begin
				if(start)
				begin
					loadRegs = 1;
					next_state = S_Loaded;
				end
			end
		S_Loaded: begin
				if(Q[0])
				begin
					addRegs = 1;
					next_state = S_Sum;
				end
				else
				begin
					shiftRegs = 1;
					next_state = S_Shifted;
				end
			 end
		S_Sum: begin
				shiftRegs = 1;
				next_state = S_Shifted;
		       end
		S_Shifted: begin
				if(zero)
					next_state = S_Idle;
				else
					next_state = S_Loaded;
			   end
	endcase
end

always@(posedge clk)
begin 
	if(loadRegs)
		begin
			B <= Multiplicand;
			Q <= Multiplier;
			A <= 0;
			C <= 0;
			P <= size;
		end
	if(addRegs)
		begin 
			{C , A} <= A + B;
		end
	if(shiftRegs)
		begin
			{C,A,Q} <= {C,A,Q} >> 1;
			P <= P - 1 ;
		end
end

assign zero = (P == 0);
assign Product = {A , Q};
endmodule
			



			
			 

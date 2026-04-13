module Simple_FSM (input clk , rst , x ,y);

parameter S0 =2'b00 ,
	  S1 =2'b01 ,
	  S2 =2'b10 ,
	  S3 =2'b11;

reg [1:0]state , next_state;

always@(posedge clk)
begin 
	if(rst)
		state <= S0;
	else
		state <= next_state;
end

always@(*)
begin
	next_state = S0;
	case(state)

		S0:begin
			if(~x)
				next_state = S0;
			else
				next_state = S1;
		   end
		
		S1:begin
			if(y)
				next_state = S3;
			else
				next_state = S2;
		   end
		S2:begin
			if( x )
			begin 
				if(y)
					next_state = S3;
				else 
					next_state = S2;
			end
			else 
				next_state = S0;
		   end
		S3:begin
			if(x)
				next_state = S0;
			else
			begin
				if(y)
					next_state = S3;
				else
					next_state = S2;
			end
		   end
		default: next_state = S0;
	endcase
end
endmodule


				

		

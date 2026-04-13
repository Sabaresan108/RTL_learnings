module MulDiv ( input [15:0] in1 , in2,
	        input clk , rst , start,
                output [15:0] result);

reg [15:0] AR , BR , CR;
reg state , next_state ;

reg load_regs , checkop ;

parameter IDLE = 1'b0,
	  CHECK = 1'b1;

assign result = CR;

always@(posedge clk , posedge rst)
begin 
	if(rst)
		state <= IDLE;
	else 
		state <= next_state;
end

always@(*)
begin 
	load_regs = 0;
	checkop   = 0;

	next_state = IDLE;

	case(state)

		IDLE:   begin 
				if(start)
				begin 
					next_state = CHECK;
					load_regs = 1;
				end
			end
		CHECK:	begin
			checkop = 1;
			next_state = IDLE;
			end
		default: next_state = IDLE;
	endcase
end

always@(posedge clk)
begin
	if(load_regs)
	begin
		AR <= in1;
		BR <= in2;
	end
	if(checkop)
	begin
		if(AR == 0)
			CR <= 0;
		
		else if(AR[15])
			CR <= {AR[15] , AR[15:1]};

		else 
			CR <= AR << 2;
	end
end

endmodule 

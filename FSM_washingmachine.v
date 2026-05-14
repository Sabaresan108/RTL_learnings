module FSM_washingmachine(input clk,rst,
			  input Start_pulse,Lid_open,Abort,
			  output Alarm,Done_tick,count);

parameter
	Idle  = 3'd00
	Wash  = 3'd01
	Drain =	3'd02
	Rinse =	3'd03
	Spin  =	3'd04;

reg [2:0] state, next_state;

always @(posedge clk)
begin
	if (~rst)
	begin
		state <= Idle;
	end
	
	else
	begin
		state <= next_state;
	end
end

always @(*)
begin
	next_state = state;

	case (state)

		Idle:
		begin
			count <= 0;
			if (Start_pulse)
			state <= Wash
		Wash:
        	begin
			if(Lid_open)
				state <= Wash;

			else if(count == 9)
			begin
				count <= 0;
				state <= Drain;
			end

			else
				count <= count + 1;
			end
		end

		Rinse:
		begin
			if(Lid_open)
				state <= Rinse;
	
			else if (count == 6)
			begin
				count <= 0;
				state <= Drain;
			end
			
			else
				count <= count + 1;
			end
		end

		Spin:
		begin
			if(Lid_open)
				state <= Spin;

			else if (count == 4)
			begin
				count <= 0;
				state <= Drain
			end
		
			else
				count <= count + 1;
			end
		end

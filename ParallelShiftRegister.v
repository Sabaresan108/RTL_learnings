module ParallelShiftRegister (input clk , rst, clr, load,
			      input [3:0]Parallel_Data,
			      input Serial_Data,
			      output [3:0] result);
reg [3:0] shift_input;
always@(posedge clk , posedge clr)
begin
	if (rst)
		shift_input <= 0;
	else if(load)
		shift_input <= Parallel_Data ;
	else
		shift_input <= {Serial_Data , shift_input[3:1] };
end

assign result = shift_input;
endmodule
	
			

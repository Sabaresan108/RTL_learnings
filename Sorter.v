module Sorter (input clk , rst , start,
	       input [7:0] Data );

reg [3:0] inner_loop , outer_loop;
reg [7:0] DataGroup [0:4];
reg [3:0] arraycounter;
reg loadarray;
always@(posedge clk)
begin
	if(rst)
	begin
		inner_loop <=4'b0;
		outer_loop <=0;
		arraycounter <= 0;
	end
	
	else if(arraycounter < 4'b0101)
		begin
			DataGroup[arraycounter] <= Data;
			arraycounter <= arraycounter + 1;
		end
	else
		loadarray <=1;
end

always@(posedge clk)
begin
	if(loadarray)
		if(outer_loop <4'b0100)
			inner_loop <=0;
			if(inner_loop < 4'b0011 - outer_loop)
			begin
				if ( DataGroup[inner_loop] > DatatGroup [inner_loop + 1] )
				begin
					DataGroup[inner_loop + 1] <= DataGroup[inner_loop]; 
					inner_loop <= inner_loop + 1;
				end
			end
			outer_loop <= outer_loop + 1;
			
endmodule 

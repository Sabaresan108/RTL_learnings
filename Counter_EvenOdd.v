module counter_evenodd(input clk,rst,
		     output reg [4:0] count);
reg Z;

always@ (posedge clk)
begin
	if (~rst)
	begin
		count <= 0;
		Z     <= 0;
	end
	
	else if (count == 5'd25)
	begin
		count <= 0;
		Z <= (count % 2)? 1 : 0;
	end
	else  
	begin
		count <= count + 1;
		Z <= count % 2;	
	end
end
endmodule 

module FIFO_Buffer ( input clk , rst , 
		     input wr_en , rd_en ,
		     input [7:0] data_in ,
		     output reg [7:0] data_out ,
		     output full , empty);

reg [3:0]wr_pt , rd_pt;	
reg [7:0]memory[0:15];
reg [4:0] count; // For setting the output flags

always@(posedge clk)
begin
	if(rst)
	begin
		wr_pt <=0;
		rd_pt <=0;
		count <=0;
	end
	else if(wr_en && !full) 
	begin
		memory[wr_pt] <= data_in;
		wr_pt <= wr_pt + 1;
		count <= count + 1;
	end
	else if(rd_en && !empty)
	begin
		data_out <= memory[rd_pt]; 
		rd_pt <= rd_pt + 1;
		count <= count - 1;
	end
end

assign empty = (count == 0);
assign full  = (count == 5'b10000);
endmodule

		
		

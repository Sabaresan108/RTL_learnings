module fifo_16( input clk, rst, wr_en, rd_en, Data,
		output full , empty,
		output reg X);

reg FIFO [0:15];
reg [3:0]wr_ptr , rd_ptr;	
reg [3:0]count;

always @(posedge clk)
begin
	if (~rst)
	begin
		count  <= 0;
		wr_ptr <= 0;
		rd_ptr <= 0;
	end
	
	else if (wr_en && ~full)
	begin
		wr_ptr <= wr_ptr + 1; 
		count  <= count  + 1;
		FIFO[wr_ptr] <= Data;
	end

	else if (rd_en && ~empty)
	begin
		rd_ptr  <= rd_ptr + 1;
		count   <= count  - 1;
		X	<= FIFO[rd_ptr];
	end
end

assign empty = count == 0;
assign full  = count == 4'd15;

endmodule 

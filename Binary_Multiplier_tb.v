module BinaryMultiplier_tb;
reg clk , rst , start;
reg [3:0] Multiplier , Multiplicand;
reg[2:0] size;
wire [7:0] Product;


BinaryMultiplier uut(clk , rst , start , Multiplier, Multiplicand, size, Product);

initial
begin
	clk = 0;
end
always #5 clk = ~clk;

initial 
begin
	rst = 1;
	#10;
	rst = 0;
	start = 1;
	Multiplier = 4'b0001;
	Multiplicand = 4'b0101;
	size = 3'b100;
	#20;
	start = 0;

end
endmodule

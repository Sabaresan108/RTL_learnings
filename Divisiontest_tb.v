module divisiontest_tb;
reg clk,rst;
wire q;

divisiontest uut ( clk ,rst, q);

initial begin
clk = 0;
end
always #5 clk = ~clk;

initial
begin
rst = 1;
#10;
rst = 0;
#1000;
end
endmodule

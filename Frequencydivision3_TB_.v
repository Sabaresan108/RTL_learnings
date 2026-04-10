`timescale 1ns/1ps
module F_3_tb;

reg clk , rst;
wire q;

F_3 uut ( clk , rst , q);

initial begin
clk = 1;
end

always #10 clk = ~clk;

initial begin
#10;
rst = 1;
#10;
rst= 0;

#1000;

end
endmodule

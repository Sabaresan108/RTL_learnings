module MulDiv_tb;
reg [15:0] in1 , in2;
reg clk , rst , start;
wire [15:0] result;

MulDiv uut (in1 , in2 , clk , rst , start , result);

initial 
begin clk = 0; end
always #10 clk = ~clk;

initial 
begin

rst=1;
#10;
rst =0;
start = 1;
in1 = 16'b0000_0000_0000_0100;
in2 = 16'b1111_1111_1111_1111;
#60;

start =0;
$finish;
end

endmodule

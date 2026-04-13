module RepeatedAddition_tb;

reg clk , rst , start;
reg [4:0] Multiplicand , Multiplier ;
wire [9:0] Product;

RepeatedAddition uut(clk , rst , start , Multiplicand , Multiplier , Product);

initial
begin 
clk=0;
end

always #5 clk = ~clk;

initial begin

rst = 1;
#10;
rst = 0;
start = 1;
Multiplicand = 5'b00001;
Multiplier = 5'b00101;
#10;
start =0;

end

endmodule

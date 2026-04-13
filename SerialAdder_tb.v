module SerialAdder_tb ;

reg clk , rst ;
reg[3:0] X , Y;
wire [3:0] Sum;
wire C;

SerialAdder uut1 (clk , rst , X , Y , Sum , C);
initial begin clk=0; end
always #5 clk = ~clk;

initial begin
rst=1;
X = 4'b 0001;
Y = 4'b 0100;
#10;
rst =0;

end
endmodule

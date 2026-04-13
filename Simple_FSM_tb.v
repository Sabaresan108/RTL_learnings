module Simple_FSM_tb;

reg clk , rst , x ,y;

Simple_FSM uut( clk , rst , x , y);
initial
begin
	clk=0;
end
always #5 clk = ~clk;

initial 
begin

#10;
x=0;

#10
y=0;

#10
x=1;y=1;

end
endmodule

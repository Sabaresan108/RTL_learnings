module ParallelShiftRegister_tb ();
reg clk , rst, clr, load;
reg [3:0]Parallel_Data;
reg Serial_Data;
wire[3:0] result;

ParallelShiftRegister uut (clk , rst , clr , load , Parallel_Data , Serial_Data , result);

initial 
begin
clk = 0;
end

always #5 clk = ~clk;

initial begin
rst = 1;
#10;
rst = 0;
clr = 0;
load = 1;
Parallel_Data = 4'b1101;
Serial_Data = 4'b0010;

#10;
load = 0;
end
endmodule

 

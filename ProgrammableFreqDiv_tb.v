`timescale 1ns/1ps
module ProgrammableFreqDiv_tb ;
reg clk_com , rst_com;
reg [1:0]freq_divisor;
wire q;

ProgrammableFreqDiv uut ( clk_com , rst_com , freq_divisor , q);
//Programmable_FreqDivFSM uut ( clk_com , rst_com , freq_divisor , q);

initial begin
clk_com = 1;
end

always #10  clk_com = ~ clk_com;

initial begin
rst_com = 1;
freq_divisor = 2'b00;
#10;
rst_com = 0;
#90;  
rst_com = 1; 
#20;
rst_com = 0;
freq_divisor = 2'b01;
#120; 
rst_com = 1;
#10;
rst_com = 0;
freq_divisor = 2'b10;
#150;
rst_com = 1; 
#20;
rst_com = 0;
freq_divisor = 2'b11;
end
endmodule


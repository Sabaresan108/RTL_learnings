`timescale 1ns/1ps
module ProgrammableFreqDivFSM_tb ;
reg clk_com , rst_com;
reg [1:0]freq_divisor;
wire q;

//ProgrammableFreqDiv uut ( clk_com , rst_com , freq_divisor , q);
Programmable_FreqDivFSM uut ( clk_com , rst_com , freq_divisor , q);

initial begin
clk_com = 1;
end

always #10  clk_com = ~ clk_com;

initial begin
rst_com = 1;
#10;
rst_com = 0;
freq_divisor = 2'b00;
#110;  
rst_com = 0; 
freq_divisor = 2'b01;
#210; 
freq_divisor = 2'b10;
#220;

freq_divisor = 2'b11;
end
endmodule


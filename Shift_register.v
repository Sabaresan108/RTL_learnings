module shift_register(input [7:0]D,
		      input Drl, 
		      input [2:0]count ,
		      input clk, rst,
		      output reg [7:0]Q);

always@ (posedge clk)
begin
	if (~rst)
	begin
		Q <= 0;
	end
	
	else
	begin
		case ({count,Drl})
			4'b000_0 : Q <= D     ;
			4'b000_1 : Q <= D     ;
			4'b001_0 : Q <= D >> 1; //right
			4'b001_1 : Q <= D << 1; // left
			4'b010_0 : Q <= D >> 2;
			4'b010_1 : Q <= D << 2;
			4'b011_0 : Q <= D >> 3;
			4'b011_1 : Q <= D << 3;
			4'b100_0 : Q <= D >> 4;
			4'b100_1 : Q <= D << 4;
			4'b101_0 : Q <= D >> 5;
			4'b101_1 : Q <= D << 5;
			4'b110_0 : Q <= D >> 6;
			4'b110_1 : Q <= D << 6;
			4'b111_0 : Q <= D >> 7;
			4'b111_1 : Q <= D << 7;
		endcase
	end										
		
end 
endmodule

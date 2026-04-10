module decoder2to4 (input A0, A1,
		    output reg [3:0] D);

always @(*)
begin
	case ({A0, A1})
		2'b00: D = 4'b0001;
		2'b01: D = 4'b0010;
		2'b10: D = 4'b0100;
		2'b11: D = 4'b1000;
		 default: D = 4'b0;
	endcase
end
endmodule

module decoder3to8 (input A2, A3, A4,EN,
		    output reg [7:0] X);

always @(*)
begin
	if (EN) 
	begin
		case ({A2, A3, A4})
			3'b000: X = 8'b00000001;
			3'b001: X = 8'b00000010;
			3'b010: X = 8'b00000100;
			3'b011: X = 8'b00001000;
			3'b100: X = 8'b00010000;
			3'b101: X = 8'b00100000;
			3'b110: X = 8'b01000000;
			3'b111: X = 8'b10000000;
				default: X=8'b0;
		endcase
	end
		else
		X = 8'b0;
end
endmodule

module decoder5to32 (input A0, A1, A2, A3, A4,
			      output [31:0] Y);

wire [3:0]EN;

	decoder2to4 mod1   (A0 , A1 , EN );
	decoder3to8 block1 (A2 , A3 , A4 , EN[0] , Y[7:0]);
	decoder3to8 block2 (A2 , A3 , A4 , EN[1] , Y[15:8]);
	decoder3to8 block3 (A2 , A3 , A4 , EN[2] , Y[23:16]);
	decoder3to8 block4 (A2 , A3 , A4 , EN[3] , Y[31:24]);

endmodule

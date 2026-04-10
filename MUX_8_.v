module MUX_8_1( input A,B,C,D,
		input  [2:0]S,
		output reg X );
always@(*)
begin 
	case(S)
		3'd0    : X =    A;
		3'd1    : X =    A & B;
		3'd2    : X =    B & C;
		3'd3    : X =    C & D;
		3'd4    : X =    D & A;
		3'd5    : X =   (A | B) & (C | D);
		3'd6    : X = ~ (A & B);
		3'd7    : X = ~((A & B) & (C & D) | (A ^ B) | (C ^ D));
		default : X =    0;
	endcase
end
endmodule

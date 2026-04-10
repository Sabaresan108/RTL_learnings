module MUX_2_1( input X,Y,
		input   Select,
		output O);

assign O = Select ? X : Y;

endmodule

module MUX_8_1( input A,B,C,D,
		input  [2:0]S,
		output Y);

wire F1,F2,F3,F4;

MUX_2_1 block0 ( A, A & B, S0, F1 );

MUX_2_1 block1 ( B & C,C & D, S0, F2 );

MUX_2_1 block2 ( D & A,(A | B) & (C | D), S0, F3 );

MUX_2_1 block3 (~(A & B) , ~(A & B)&(C & D)|(A ^ B)|(C ^ D), S0, F4 );

wire F5,F6;

MUX_2_1 block4 ( F1, F2, S1, F5 );

MUX_2_1 block5 ( F3, F4, S1, F6 );

wire F7;

MUX_2_1 block6 ( F5, F6, S2, F7 );

endmodule 

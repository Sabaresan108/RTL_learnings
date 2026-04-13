module SerialAdder (input clk , rst ,
		    input [3:0] X , Y,
		    output [3:0] Sum,
		    output C);
wire a , b , ci;
wire s , co;
reg [3:0] in1 , in2;
reg carry;
reg [2:0] counter;
assign a = in1[0];
assign b = in2[0];
assign ci = carry;
FullAdder uut ( a , b , ci , s ,co);

always@(posedge clk)
begin
	if(rst)
	begin
		in1 <= X;
		in2 <= Y;
		carry<=0;
		counter<= 0;
	end
	else
	begin
		if(counter <= 3'b011)
		begin
			in1 <= {s,in1[3:1]};
			in2 <= in2 >> 1;
			carry <= co;
			counter<=counter+1;
		end
	end
end
assign Sum = in1;
assign C = co;
endmodule
		
		

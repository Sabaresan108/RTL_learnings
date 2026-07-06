module TM1637_Number_set(input [3:0]hex_value,
                         output reg [7:0] data);

always @(*)
begin
     case(hex_value)
                 4'h0: data = 8'h3F; 
                 4'h1: data = 8'h06;
                 4'h2: data = 8'h5B; 
                 4'h3: data = 8'h4F;
                 4'h4: data = 8'h66; 
                 4'h5: data = 8'h6D;
                 4'h6: data = 8'h7D; 
                 4'h7: data = 8'h07;
                 4'h8: data = 8'h7F; 
                 4'h9: data = 8'h6F;
                 
                 default: data = 8'h00;  
        endcase
end
endmodule

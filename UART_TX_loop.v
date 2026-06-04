module UART_TX(input clk,rst,tx_start,
               input [7:0] data_in,
               output reg data_out,
               output reg [3:0] LED,
               output [13:0]baud_count);

reg [13:0] baud_counter;
reg [3:0] bit_count;
reg [1:0] state;
reg [7:0] data;
          
parameter
        IDLE   = 2'b00,
        MAIN   = 2'b01;    

always @(posedge clk)
begin
       if (~rst)
       begin
            baud_counter <= 0;
            bit_count    <= 0;
            data_out     <= 1;
            state        <= IDLE;
            data         <= 0;
            LED  <= 0;
       end
        
        
       else 
       begin
     
              case (state)
                           IDLE:
                           begin
                                 data_out <= 1;
  
                                 if(tx_start)
                                 begin
                                       data     <= data_in;        
                                       data_out <= 0;
                                       bit_count <= 0;
                                       baud_counter <= 0; 
                                       state <= MAIN;
                                       LED <= 4'b1010;
                                 end
                           end
                           
                       
                           MAIN:
                           begin
                                if ( baud_counter == 1084 ) // 125MHZ/115200HZ
                                begin
                                     baud_counter <= 0;

                                    if(bit_count < 8)
                                    begin
                                         data_out <= data[bit_count];
                                         bit_count <= bit_count+1;
                                    end
                                    
                                    else if (bit_count == 8)
                                    begin
                                         data_out <= 1;
                                         bit_count <= bit_count+1;

                                    end 
                                       
                                    else
                                    begin
                                         state  <= IDLE;
                                         bit_count <= 0;
                                         data_out  <= 1;
                                         LED <= 4'b1111; 
                                    end
                                end
                                
                                else
                                     begin
                                          baud_counter <= baud_counter +1;
                                     end
                           end
              endcase
       end
       
       
end

assign baud_count =  baud_counter;

endmodule

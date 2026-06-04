module UART_TX(input clk,rst,tx_start,
               output reg data_out,
               output reg LED);

reg[7:0] data_in = 8'b11100111;
reg [13:0] baud_counter;
reg [3:0] bit_count;
reg state;
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
            LED  <= 1;
       end
        
       else if(baud_counter == 13019) // 125MHZ/9600HZ
       begin
              baud_counter <= 0;
     
              case (state)
                           IDLE:
                           begin
                                 data_out <= 1;
  
                                 if(tx_start)
                                 begin
                                       data     <= data_in;        
                                       data_out <= 0;
                                       bit_count <= 0;
                                       state <= MAIN;
                                 end
                           end
                           
                       
                           MAIN:
                           begin
                                if(bit_count < 8)
                                begin
                                     data_out <= data[bit_count];
                                     bit_count <= bit_count+1;
                                end
                                    
                                else if(bit_count == 8)
                                begin
                                      data_out <= data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7];
                                      bit_count <= bit_count+1;
                                end
                                else if(bit_count == 9)
                                begin
                                    data_out  <= 1;
                                    bit_count <= bit_count+1;
                                end
                                else if(bit_count == 10)
                                begin
                                    state <= IDLE;
                                    bit_count <= 0;
                                end
                                    
                                        
                           end
                           
              endcase
       end
       
       else
        begin
             LED  <= 0;
             baud_counter <= baud_counter +1;
        end


end

endmodule

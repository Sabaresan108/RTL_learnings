
module UART_RX(input clk,rst,rx_start,
               output reg [7:0] rx_data,
               output reg [3:0] LED,
               output reg rx_done);

reg [10:0] baud_counter;
reg [3:0] bit_count;
reg [1:0] state;

parameter IDLE  = 2'b00,
          START = 2'b01,
          DATA  = 2'b10,
          DONE  = 2'b11;

always @(posedge clk)
begin
    if(~rst)
    begin
        baud_counter <= 0;
        bit_count    <= 0;
        rx_done      <= 0;
        LED          <= 0;
        state        <= IDLE;
        rx_data      <= 0;
    end
    
    else
    begin
        case(state)

        IDLE:
        begin
            rx_done <= 0;
            if(rx_start == 0)
            begin
                rx_data      <= 0;
                baud_counter <= 0;
                bit_count <= 0;
                state <= START;
            end
        end
        
        START:
        begin
             if(baud_counter == 542) //baud rate = 1084/2
             begin
                  baud_counter <= 0;

                   if(rx_start == 0)
                   begin
                        bit_count <= 0;
                        state <= DATA;
                   end
        
                   else
                   begin
                        state <= IDLE;
                   end
             end
                else
                begin
                     baud_counter <= baud_counter + 1;
                end
        end
            
        DATA:
        begin
            if(baud_counter == 1084) //125MHZ/115200HZ
            begin
            
                baud_counter <= 0;
                rx_data[bit_count] <= rx_start;


                if(bit_count == 7)
                begin
                    state <= DONE;
                end
                
                else
                begin
                    bit_count <= bit_count + 1;
                end
            end
            else
            begin
                baud_counter <= baud_counter + 1;
            end
        end
        

        DONE:
        begin
            if(baud_counter == 1084) //125MHZ/115200HZ
            begin
              rx_done      <= 1;
             
             
             case(rx_data)
                                8'h30: LED <= 4'b0000; // 0
                                8'h31: LED <= 4'b0001; // 1
                                8'h32: LED <= 4'b0010; // 2
                                8'h33: LED <= 4'b0011; // 3
                                8'h34: LED <= 4'b0100; // 4
                                8'h35: LED <= 4'b0101; // 5
                                8'h36: LED <= 4'b0110; // 6
                                8'h37: LED <= 4'b0111; // 7
                                8'h38: LED <= 4'b1000; // 8
                                8'h39: LED <= 4'b1001; // 9
                                8'h41: LED <= 4'b1010; // A
                                8'h42: LED <= 4'b1011; // B
                                8'h43: LED <= 4'b1100; // C
                                8'h44: LED <= 4'b1101; // D
                                8'h45: LED <= 4'b1110; // E
                                8'h46: LED <= 4'b1111; // F


             endcase
                            bit_count    <= 0;
                            baud_counter <= 0;             
                            state        <= IDLE;
        end
         else
            begin
                baud_counter <= baud_counter + 1;
            end
        end

        default:
            state <= IDLE;

        endcase

    end
end

endmodule

module UART_sequence_detector(input clk,rst,rx_start,
                 output tx_out,
                 output [3:0] LED);

reg  [31:0]timeout_counter;
wire [13:0] baud_count;
wire [7:0] rx_data;
reg  [7:0] tx_data;
reg  [7:0] count;
wire [3:0] led_1;
reg  [7:0] ones;
reg  [7:0] tens;
reg  [7:0] hundreds;
reg tx_start_reg;
wire tx_done;
wire rx_done;
wire tx_led; 
reg stop;
reg sent;

reg [1:0] state;

parameter 
          IDLE      = 2'b00,
          HUNDRED   = 2'b01,
          TENS      = 2'b10,
          ONES      = 2'b11;


UART_TX Sending     (clk , rst , tx_start_reg , tx_data ,  tx_out, tx_done , led_1, baud_count);

UART_RX Receiving   (clk , rst ,rx_start , rx_data , LED  ,rx_done);

always @(posedge clk)
begin

    if(~rst)
    begin
         count           <= 0;
         tx_start_reg    <= 0;
         tx_data         <= 0;
         stop            <= 0;
         timeout_counter <= 0;
         ones            <= 0;
         tens            <= 0;
         hundreds        <= 0;
         sent            <= 0;
         state           <= IDLE;
    end

    else
    begin
         case (state)
           
         IDLE:
         begin
              tx_start_reg <= 0;
         end
           
         HUNDRED:
         begin
               if (!sent)
               begin
                    tx_data      <= hundreds + 8'd48;
                    tx_start_reg <= 1;
                    sent         <= 1;
               end
               
               else
               begin
                    tx_start_reg <= 0;
               
                   if(tx_done)
                   begin
                        sent  <= 0;
                        state <= TENS;
                   end
              end
         end  
    
         TENS:     
         begin
              tx_start_reg <= 0;

              if(!sent)
              begin
                   tx_data      <= tens + 8'd48;
                   tx_start_reg <= 1;
                   sent         <= 1;
              end
              
              else
              begin
                   tx_start_reg <= 0;
              
              
                  if (tx_done)
                  begin
                       sent   <= 0;
                       state  <= ONES;
                  end
              end
         end

         ONES:
         begin
              tx_start_reg <= 0;
              
              if(!sent)
              begin
                   tx_data      <= ones + 8'd48;
                   tx_start_reg <= 1;
                   sent         <= 1;
              end
              
              else
              begin
                   tx_start_reg <= 0;

                   if(tx_done)
                   begin
                        sent         <= 0;
                        count        <= 0;
                        state        <= IDLE;
                   end
              end
         end
         
         endcase
         
        if(rx_done)
        begin

             stop            <= 0; 
             timeout_counter <= 0;
            
                if(rx_data == 8'h41 || rx_data == 8'h61)
                begin  
                     count <= count + 1;
                end
        end

        else
        begin 
            timeout_counter <= timeout_counter + 1;
        end
        

        if(timeout_counter == 32'd62500000 && ~stop )
        begin

             hundreds        <= count / 100;
             tens            <= (count % 100) / 10;
             ones            <= count % 10;            
             timeout_counter <= 0;
             sent            <= 0;
             stop            <= 1;
             state           <= HUNDRED;

        end
    end    
end
    
endmodule

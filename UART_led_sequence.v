module UART_led_100_bytes(input clk,rst,rx_start,
                          output reg [3:0] LED);
  
integer i;                         
wire rx_done;
wire [7:0] rx_data;
wire [3:0] LED_1; 
reg  [2:0] state;
reg  [2:0] led_num;
reg  [15:0] time_sec;
reg  [31:0] led_period [0:3];
reg  [31:0] led_counter[0:3];

parameter
           IDLE      = 3'd00,
           CMD_L     = 3'd01,
           CMD_E     = 3'd02,
           CMD_D     = 3'd03,
           CMD_NUM   = 3'd04,
           CMD_TIME  = 3'd05;
                     
UART_RX Receiving   (clk , rst ,rx_start , rx_data , LED_1  ,rx_done);

always @(posedge clk)
begin
    if(~rst)
    begin
            LED         <= 0;
            led_num     <= 0;
            time_sec    <= 0;
            state       <= IDLE;
            
            for(i=0;i<4;i=i+1)
            begin
                 led_counter[i] <= 0;
                 led_period[i]  <= 0;
            end
    end   
    
    else if(rx_done)
    begin
          case(state)
          
                IDLE :
                begin

                  if(rx_data == "L")  //L
                  begin
                     state <= CMD_L;
                  end
                  
                  else
                  begin
                       state <= IDLE;
                  end
                     
                end
                
                CMD_L :
                begin
                     if(rx_data == "E")  //E
                     begin
                          state <= CMD_E;
                     end
                     
                     else
                     begin
                          state <= IDLE;
                     end     
                end
                
                CMD_E :
                begin
                     if(rx_data == "D")  //D
                     begin
                          state <= CMD_D;
                     end
                     
                     else
                     begin
                            state <= IDLE;
                     end
                end
                
                CMD_D :
                begin
                      if(rx_data >= 8'h31 && rx_data <= 8'h34) //LED_NUM
                      begin
                            led_num <= rx_data - 8'h30;
                            state <= CMD_NUM;
                end
                     else
                        state <= IDLE;
                end
                
                CMD_NUM :
                begin
                      if(rx_data == 8'h20)  //SPACE
                      begin
                            time_sec <= 0;
                            state    <= CMD_TIME;
                      end
                      
                      else
                      begin
                          state <= IDLE;
                      end    
                end
                
                CMD_TIME :
                begin
                     if(rx_data >= 8'h30  && rx_data <= 8'h39 )  //TIME
                     begin
                          time_sec <= (time_sec * 10) + (rx_data - 8'h30 );
                     end

                    else if(rx_data == 8'd13 || rx_data == 8'd10)
                    begin
                          case(led_num)
                          
			                     3'd01 : led_period[0] <= time_sec; 
			                     3'd02 : led_period[1] <= time_sec;
			                     3'd03 : led_period[2] <= time_sec;
			                     3'd04 : led_period[3] <= time_sec;
			               
			              endcase
			                
			              time_sec <= 0;
                          led_num  <= 0;
                          state <= IDLE;
                    end
                    
                    else
                    begin
                         state <= IDLE;
                    end
                end
          endcase
    end
             
             for( i=0 ; i<4 ; i=i+1 ) //TIMER
             begin

                   if(led_period[i] != 0)
                   begin

                        if(led_counter[i] >= (led_period[i] * 125_000_000))//125 MHZ
                        begin
                             led_counter[i] <= 0;
                             LED[i] <= ~LED[i];
                        end

                        else
                        begin
                             led_counter[i] <= led_counter[i] + 1;
                        end
                   end
             end
end

endmodule

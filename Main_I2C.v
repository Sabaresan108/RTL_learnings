module Main_I2C(input clk,rst,start,ReadWrite,
                input [7:0]data_in,
                inout sda,
                output reg data_valid,
                output reg [2:0] state,
                output reg scl,
                output reg [7:0] rx_data,
                
                input uart_start,
                input [7:0] uart_hrs,
                input [7:0] uart_min,
                input [7:0] uart_sec,
                output uart_tx_pin);

reg [7:0] data_storage;
reg [7:0] wait_counter;                
reg [8:0] counter;
reg [4:0] count;
reg repeat_receive;
reg enable;
reg s_out;

wire tx_valid;
wire [3:0] global_counter;
wire [7:0] input_data1;

UART_TX  uut (clk , rst , uart_start , uart_hrs , uart_min , uart_sec , uart_tx_pin , tx_valid , global_counter , input_data1);

parameter
            IDLE       = 3'b000,
            START      = 3'b001, 
            ACK        = 3'b010,
            STOP       = 3'b011,
            READ       = 3'b100,
            ACK_MAIN   = 3'b101,
            RESTART    = 3'b110,
            NACK       = 3'b111;

assign sda = enable ? s_out : 1'bz;

always @(posedge clk)
begin
     if (~rst)
     begin
           s_out          <= 1;
           scl            <= 1;
           counter        <= 0;
           count          <= 0;
           enable         <= 0;
           state          <= IDLE; 
           wait_counter   <= 0; 
           repeat_receive <= 0;  
           rx_data        <= 0;
           data_valid     <= 0;  
     end
     
      else
      begin
           data_valid <= 0;   
           if (state != IDLE)
           begin
                counter <= counter + 1;           
                if (counter == 170 && ~scl )
                begin
                     scl     <= 1;
                     counter <= 0;
                end
               
                else if (counter == 144 && scl )
                begin
                      scl     <= 0;
                      counter <= 0;
                end 
           end  
           else
           begin
                counter <= 0;                
           end 
           case(state)
                  IDLE:
                  begin
                       enable <= 1;  
                       s_out  <= 1;
                       if(start)
                       begin
                            if(wait_counter ==  7'd75)  
					        begin
						         wait_counter 	<= 0;
						         s_out   		<= 0;       
						
						         if(ReadWrite)
						         begin
							          state <= READ; 
						         end
						
						         else if(~ReadWrite)
						         begin
							          state <= START;
						         end      
					        end
					
					        else if(wait_counter < 7'd75)
					        begin
						         wait_counter <= wait_counter + 1;
					        end
				        end
                  end
                  
                  START:
                  begin
                        data_valid  <= 0;                    
                       if(~scl && counter == 7'd80) 
                       begin
                            enable <= 1;
                            if(count < 4'd8) 
                            begin
                                s_out    <= data_in [3'd7 - count];
                                count    <= count + 1;
                            end
                            else if(count == 4'd8)
                            begin
                                count    <= 0;
                                enable   <= 0;
                                state    <= ACK;
                            end
                        end 
                  end       
                  
                  ACK:
                  begin
                       if(scl && counter == 7'd80 && ~sda && ~start)
				       begin
					        state 		<= STOP;
					        data_valid	<= 1;
				       end
				       
				       else if(scl && counter == 7'd80 && ~sda && start && ReadWrite)    
				       begin
					        state       <= READ;
					        data_valid  <= 1;
				       end
				       
				       else if(scl && counter == 7'd80 && ~sda && start && ~ReadWrite)    
				       begin
					        state       <= START;
					        data_valid  <= 1;
				       end
                  end
                  
                  STOP:
                  begin
                       data_valid <= 0;
                       if(scl && counter == 7'd13) 
                       begin
                            if(~repeat_receive)
                            begin      
                                 s_out   <= 1;  
                                 state   <= IDLE;
                            end
                            
                            else 
                            begin
                                 s_out   <= 1'd1;
                                 state <= READ;
                                 repeat_receive <= 0;
                            end
                       end
                  end
                          
                  READ:
                  begin
                       data_valid <= 0;
                       if(~scl && counter == 7'd13)  
                       begin
                            enable <= 0;                        
                       end
                       
                       else if(scl && counter == 7'd13 && ~enable)
                       begin
                            if(count < 4'd7)
                            begin
                                 data_storage[4'd7 - count] 	<= sda;
                                 count              			<= count + 1;
                            end
                        
                            else if(count == 4'd7)
                            begin
                                 count          <= 0;
                                data_storage[0] <= sda;
                                state           <= ACK_MAIN;
                            end 
				        end
				  end      
				  
				  ACK_MAIN:
				  begin
                       if(~scl && counter == 7'd2 && start)
                       begin
                            enable          <= 1;
                       end
                       if(~scl && counter == 7'd13 && start)
                       begin
                            repeat_receive 	<= 1;
                            s_out 			<= 0; // ACK 
                            data_valid 		<= 1;
                            state 			<= READ;
                            rx_data     	<= data_storage;
                       end
                       else if(~scl && counter == 7'd13 && ~start)
                       begin
                            s_out			<= 1; //NACK
                            data_valid		<= 1;
                            rx_data 	    <= data_storage;
                            state  	 		<= NACK;
                       end
                  end
                  
                  RESTART:
			      begin
			           data_valid <= 0;     
				       if(~scl && counter == 7'd13 )
				       begin
					        s_out   <= 1;
				       end
				
				       else if(scl && counter == 7'd5) 
				       begin
					        state   <= IDLE; 
				       end
			      end
			      
			      NACK:
                  begin
                       data_valid <= 0;
                       if(~scl && counter == 7'd13)
                       begin
                            state   <= STOP;
                            s_out	<= 0;
                       end
                  end  
                            
           endcase
      end 
end
endmodule

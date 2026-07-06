`timescale 1ns / 1ps
module TM1637_CON (input clk,rst,
   			       inout d_io,
   			       output d_clk,
   			       output reg [3:0] LED);

   
reg [7:0] data_in;
reg [1:0] state;
reg [3:0] step; 
reg stop_tx;          
reg start;
wire data_valid;
wire ready;
wire d_in1;
wire [1:0]state1;
reg start_display;
reg cmd1;
reg [26:0] count_sec;
reg [3:0] ones,tens,hundreds,thousands;
reg [7:0] num0,num1,num2,num3;
reg [13:0]sec;
reg [3:0] hex_value;
wire [7:0] data1;
reg [7:0]data;
reg [2:0]num_count;
reg sec_over;
reg sec_over_reg;

TM1637_MASS uut (clk ,rst ,start ,cmd1 ,data_in ,stop_tx ,d_io ,ready ,data_valid ,d_clk , state1 , d_out1 , d_in1);
TM1637_Number_set uu3t (hex_value, data1);
ila_0 uu4t (clk , data_valid , d_out1 , state1 , d_in1 , sec[3:0] , data_in , step , num0,start);

parameter
         IDLE        = 2'b00,
         START       = 2'b01,
         WAIT        = 2'b10,
         WAIT_SEC    = 2'b11; //WAIT FOR 1 SECOND

always @(posedge clk) 
begin
     if (~rst) 
     begin
          state         <= IDLE;
          start         <= 0;
          data_in       <= 0;
          step          <= 0;
          stop_tx       <= 0;
          sec           <= 0;
          num_count     <= 0;
          hex_value     <= 0;
          sec_over      <= 0;
          sec_over_reg  <= 0 ;
          start_display <= 1;
          cmd1          <= 1;
          count_sec     <= 27'd0;
          LED           <= 4'b0000;
     end 
        
     else 
     begin
            if(state != IDLE)
            begin
                 if(count_sec == 125000000)
                 begin 
                       count_sec <= 0;
                       sec       <= sec + 1; 
                       sec_over  <= 1;
                       LED           <= ~LED;
                 end   
                 else
                 begin
                    count_sec <= count_sec + 1;
                    sec_over <= 0;
                 end
            end
            
            else if (state == IDLE)
            begin
                 sec <= 0;
            end            

          
          case (state)
                    IDLE: 
                    begin
                         if (start_display) 
                         begin
                              step          <= 1;          
                              start_display <= 0;
                              state         <= WAIT_SEC;
                         end
                    end
                    
                    WAIT_SEC:
                    begin
                        if(sec_over ||sec_over_reg )
                        begin
                            if (num_count == 0)
                            begin
                                 ones      <=  sec % 10;
                                 tens      <= (sec / 10) % 10;
                                 hundreds  <= (sec / 100) % 10;
                                 thousands <= (sec / 1000) % 10;
                                 
                                 num_count <= 1; 
                                 sec_over_reg <= 1; 
                            end
                            
                            else if (num_count == 1)
                            begin
                                 num_count <= 2;  
                                     
                                 hex_value <= ones;
                            end
                                 
                              else if (num_count == 2)
                              begin
                                     hex_value <= tens;
                                     num0      <= data1;
                                     num_count <= 3;  
                                     
                                end
                                
                              else if (num_count == 3)
                              begin
                                     hex_value <= hundreds;
                                     num1      <= data1 ;
                                     num_count <= 4;  
                              end
                                
                              else if (num_count == 4)
                              begin
                                     hex_value <= thousands;
                                     num2      <= data1 ;
                                     num_count <= 5;            
                              end
                                    
                              else if (num_count == 5)
                              begin
                                     num3       <= data1 ;
                                     num_count  <= 0;
                                     sec_over_reg <= 0;
                                     state      <= START;
                                     
                              end
    
                            end
                        end

                    START: 
                    begin       
                        if (step == 1) // Cmd 1: Instruction
                        begin
                             start <= 1;
                             data_in <= 8'h40;  // write value
                             stop_tx <= 0;
                        end
                        
                        else if (step == 2) // Cmd 2: Address
                        begin
                             start <= 1;
                             data_in <= num3; //  Digit 1
                             stop_tx <= 1;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 3) // Cmd 3: DATA
                        begin
                             start <= 1;
                             data_in <= num2; // Digit 2  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 4) // Cmd 3: DATA
                        begin
                             start <= 1;
                             data_in <= num1; // Digit 3  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 5) // Cmd 3: DATA
                        begin
                             start <= 1;
                             data_in <= num0; // Digit 4  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end     
                        
                         else if (step == 6) // Cmd 3: DATA
                        begin
                             start <= 1;
                             data_in <= 8'h7D; // Digit 3  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 7) // Cmd 3: DATA
                        begin
                             start <= 1;
                             data_in <= 8'h6F; // Digit 4  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end     
                       
                        else if (step == 8) // Cmd 4: Turn Display ON
                        begin
                             start <= 1;
                             data_in <= 8'h8F; //ON
                             stop_tx <= 1;
                             cmd1    <= 1;
                                  
                        end
                    
                        state <= WAIT;
                    end
                WAIT: 
                begin
                       
                     if (data_valid)
                     begin
                           start <= 0;
                     
                         if (step == 8 && sec != 9999)
                         begin
                              step  <= 1;
                              state <= WAIT_SEC; 
                              
                         end 
                         else if(sec == 9999 && step == 8)
                         begin
                            state <= IDLE;
                         end
                         else 
                         begin
                              step  <= step + 1; 
                              cmd1  <= 0;
                              state <= START;

                         end
                     end
                end
          endcase
     end
end
endmodule

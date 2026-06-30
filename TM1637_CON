`timescale 1ns / 1ps
module TM1637_CON (input clk,rst,
   			       inout d_io,
   			       output d_clk,
   			       output reg [3:0] LED);

reg [7:0] data_in;
reg [1:0] state;
reg [2:0] step; 
reg stop_tx;          
reg start;
wire data_valid;
wire ready;
wire d_in1;
wire [1:0]state1;
reg cmd1;
reg start_display ;
TM1637_MASS uut (clk    ,rst    ,start,cmd1,data_in,stop_tx,d_io,ready,data_valid,d_clk , state1 , d_out1 , d_in1);
ila_0 uu2t      (clk    , d_clk ,  state1 , d_out1 , step , data_in);

parameter
         IDLE  = 2'd0,
         START = 2'd1,
         WAIT  = 2'd2;

always @(posedge clk) 
begin
     if (~rst) 
     begin
          state         <= IDLE;
          start         <= 0;
          data_in       <= 0;
          step          <= 0;
          stop_tx       <= 0;
          start_display <= 1;
          cmd1          <= 1;
          LED           <= 4'b0000;
     end 
        
     else 
     begin

          case (state)
                    IDLE: 
                    begin
                         if (start_display && ready) 
                         begin
                              step       <= 1;          
                              state <= START; 
                              start_display <= 0;
                         end
                    end

                    START: 
                    begin

                    
                        if(step == 1) // Cmd 1: Instruction
                        begin
                             start <= 1;
                             data_in <= 8'h40;  // fixed value
                             stop_tx <= 0;
                        end
                        
                        else if (step == 2) // Cmd 2: Address
                        begin
                            start <= 1;
                             data_in <= 8'h3F; //  Digit 1
                             stop_tx <= 1;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 3) // Cmd 3: DATA
                        begin
                            start <= 1;
                             data_in <= 8'h06|8'h80; // DATA  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 4) // Cmd 3: DATA
                        begin
                            start <= 1;
                             data_in <= 8'h5B; // DATA  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end
                        
                        else if (step == 5) // Cmd 3: DATA
                        begin
                            start <= 1;
                             data_in <= 8'h4F; // DATA  
                             stop_tx <= 0;
                             cmd1    <= 0;
                        end     
                       
                        else if (step == 6) // Cmd 4: Turn Display ON
                        begin
                            start <= 1;
                             data_in <= 8'h8F; //ON
                             stop_tx <= 1;
                             cmd1    <= 1;
                             LED     <= 4'b1111;
                        end
                    
                        state <= WAIT;
                    end
                WAIT: 
                begin
                       
                     if (data_valid)
                     begin
                            start <= 0;
                     
                         if (step == 6)
                         begin
                              step  <= 0;
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

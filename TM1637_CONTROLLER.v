module TM1637_CONTROLLER (input clk,rst, start_display,
   			             inout d_io,
   			             output d_clk);

reg [7:0] data_in;
reg [1:0] state;
reg [2:0] step; 
reg stop_tx;          
reg start;
wire data_valid;
wire ready;
reg cmd1;

TM1637_MASTER1 uut (clk,rst,start,cmd1,data_in,stop_tx,d_io,ready,data_valid,d_clk);

parameter
         IDLE  = 2'd0,
         START = 2'd1,
         WAIT  = 2'd2;

always @(posedge clk) 
begin
     if (~rst) 
     begin
          state      <= IDLE;
          start      <= 0;
          data_in    <= 0;
          step       <= 0;
          stop_tx    <= 0;
          cmd1 <= 1;
     end 
        
     else 
     begin
           start <= 0; 

          case (state)
                    IDLE: 
                    begin
                         if (start_display && ready) 
                         begin
                              step       <= 1;          
                              state <= START; 
                         end
                    end

                    START: 
                       
                    begin
                         start <= 1; 
                    
                        if(step == 1) // Cmd 1: Instruction
                        begin
                             data_in <= 8'h44;  // fixed value
                             stop_tx <= 0;
                        end
                        
                        else if (step == 2) // Cmd 2: Address
                        begin
                             data_in <= 8'hC0; //  Digit 1
                             stop_tx <= 1;
                        end
                        
                        else if (step == 3) // Cmd 3: DATA
                        begin
                             data_in <= 8'h3F; // DATA  
                             stop_tx <= 0;
                        end
                        
                        else if (step == 4) // Cmd 4: Turn Display ON
                        begin
                             data_in <= 8'h8F; //ON
                             stop_tx <= 0;
                        end
                    
                        state <= WAIT;
                    end
                WAIT: 
                begin

                     if (data_valid)
                     begin
                         if (step == 4)
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

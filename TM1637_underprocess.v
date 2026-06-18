
module TM1637_master(input clk,rst,start,
                     input [7:0] data_in,
                     inout d_io,
                     output reg d_clk);
 
reg [11:0] count;
reg [3:0] counter;
reg [7:0] tx_data;
reg [1:0] state;
reg enable;
reg d_out;
 
 parameter
          IDLE  = 2'b00,
          START = 2'b01,
          ACK   = 2'b10,
          STOP  = 2'b11;
          
assign d_io = enable ? d_out : 1'bz;

always@ (posedge clk)
begin
     if(~rst)
     begin
          state   <= IDLE;
          tx_data <= 0;
          counter <= 0;
          count   <= 0;
          d_clk   <= 1;
          d_out   <= 1;
          enable  <= 1;         
     end
 
 /// clk division part    
     else if (count == 313 && d_clk == 0)
     begin
          d_clk <= 1;
          count <= 0;
     end
     
     else if (count == 312 && d_clk == 1)
     begin
          d_clk <= 0;
          
          count <= 0;
     end

     else
     begin
          count <= count + 1;
     end     
////     
     
          case(state)
                  IDLE:
                  begin
                        d_clk <= 1;
                        d_out <= 1;
                        
                        if(start)
                        begin
                             tx_data <= data_in;
                             state   <= START;
                             d_out   <= 0;   
                             
                        end
                  end
                  
                  START:
                  begin
                        if (counter < 4'd8 && d_clk )
                        begin
                        d_out <= tx_data[counter];
                        counter <= counter + 1;                        
                        end
                        
                        else
                        begin
                             enable  <= 0;
                             counter <= 0;
                             state   <= ACK;
                        end
                  end
                  
                  ACK:
                  begin
                       if(d_out == 0)
                       begin
                            enable <= 1;
                            state <= START;
                       end
                       
                       else
                       begin
                            enable <= 1;
                            state  <= STOP; 
                       end
                  
                  end
                  
                  STOP:
                  begin
                        d_clk  <= 1;
                        d_out  <= 1;
                        enable <= 1;
                        state  <= IDLE;
                  end 
          endcase
end            
endmodule

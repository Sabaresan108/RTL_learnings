module I2C_Master(input clk, rst,start,ReadWrite,
                  input [7:0] data,
                  inout sda,
                  output scl,
                  output sdainput_ila,
                  output sdaoutput_ila,
                  output enable1,
                  output reg data_valid,
                  output reg [3:0] led1,
                  output [2:0] state1,
                  output [3:0] data_counter1,
                  output sda_listener,
                  output [8:0] i2c_counter_debug);
                      
parameter 
    IDLE                = 3'b000,
    START_DATA          = 3'b001,
    RECEIVE_DATA        = 3'b010,
    STOP                = 3'b011,
    ACKNOWLEDGE_DATA    = 3'b100,
    ACKNOWLEDGE_MASTER  = 3'b101;
    
reg [8:0] i2c_counter;   // 125 MHz clock divider counter
reg [6:0] wait_counter;
reg [3:0] data_counter;
reg       SCL, SDA;
reg [2:0] state;
reg       enable;
reg [7:0] data_storage;

assign sda = enable ? SDA : 1'bz; // Tristate SDA control

always @(posedge clk) 
begin
     if (~rst) 
     begin
     	  SCL          <= 1;
          SDA          <= 1;
          i2c_counter  <= 0;
          wait_counter <= 0;
          state        <= IDLE;
          enable       <= 1;
          data_counter <= 0;
          data_valid   <= 0;
         led1          <= 4'b0001;
     end
    
     else 
     begin
          if (state != IDLE) 
	  begin
               i2c_counter <= i2c_counter + 1;
               if (SCL && i2c_counter == 9'd144) 
 	       begin
                    SCL         <= 0;
                    i2c_counter <= 0;
               end
          	
		else if (~SCL && i2c_counter == 9'd170) 
		begin
                     SCL         <= 1;
                     i2c_counter <= 0;
          	end
          end
        
	  else 
	  begin
              i2c_counter <= 0;
          end   
         
          case (state)
             IDLE: //0
	         begin
                  enable <= 1;
                  SDA    <= 1;
                  
                  if (start) 
                  begin
                       if (wait_counter == 7'd80) // T_SU:STA Setup Delay
                       begin 
                             wait_counter <= 0;
                             state        <= START_DATA;
                             SDA          <= 0;              
                       end
                               
                       else 
                       begin
                            wait_counter <= wait_counter + 1;
                       end
                  end
             end
                    
             START_DATA: //1
	         begin
                  data_valid <= 0;
                  if (~start && data_counter == 0) 
		          begin
                       if (~SCL && i2c_counter == 9'd79) 
		               begin                   
                            state  <= STOP;
                            enable <= 1;
                            led1    <= 4'b0110;
                            SDA    <= 0;
                       end
                  end
                  
		          else if (~SCL && i2c_counter == 9'd79) 
		          begin
                       enable <= 1;
                     
		              if (data_counter < 4'd8) 
		              begin
                           SDA          <= data[3'd7 - data_counter];
                           data_counter <= data_counter + 1;
                      end
                    
		              else if (data_counter == 4'd8) 
		              begin
                           data_counter <= 0;
                           enable       <= 0;
                           state        <= ACKNOWLEDGE_DATA;
                       end
                  end                    
             end
            
             ACKNOWLEDGE_DATA: //4
	         begin
    		      led1 <= 4'b1101;
    
   		          if (SCL && i2c_counter == 9'd79) 
		          begin
        	           if (~sda) 
		               begin 
	                        data_valid <= 1;
                           
                            if (start)
                            begin 
                                 state <= START_DATA;
                            end
                               
                            else 
                            begin       
                                 state <= STOP;
                            end
                       end
                      
                       else 
                       begin 
                            state <= STOP; 
                       end
                  end
	         end
            
             STOP: //3
             begin
                  data_valid <= 0;
                  if (SCL && i2c_counter == 9'd79)
                  begin
                       SDA   <= 1;
                       state <= IDLE;
                       led1   <= 4'b0110;
                       data_counter <= 0;
                  end
            end
               
            RECEIVE_DATA: //2
	        begin   
                 if (~SCL && i2c_counter == 9'd79) 
		         begin
                      enable <= 0;                        
                 end

                 else if (SCL && i2c_counter == 9'd79) 
		         begin
                      if (data_counter < 4'd8) 
		              begin
                      	   data_storage[data_counter] <= sda;
                           data_counter               <= data_counter + 1;
                      end

                      else if (data_counter == 4'd8) 
		              begin
                           data_counter <= 0;
                           enable       <= 1;
                           state        <= ACKNOWLEDGE_MASTER;
                      end
                 end
            end
            
            ACKNOWLEDGE_MASTER: //5
	        begin
                 if (~SCL && i2c_counter == 9'd79) 
		         begin
                      SDA <= 1; // NACK
                 end
                 else if (SCL && i2c_counter == 9'd79) 
		         begin
                      state <= STOP;
                 end
            end                                   
          endcase
      end
end

assign scl           = SCL;
assign sdainput_ila  = enable ? SDA : 0;
assign sdaoutput_ila = ~(enable) ? sda : 1;
assign i2c_counter_debug = i2c_counter;
assign sda_listener  = sda;
assign enable1       = enable;
assign state1        = state;
assign data_counter1 = data_counter;

endmodule

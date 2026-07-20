module DS3231(input clk,rst,RW_start,
              inout sda,
              output scl,
              inout d_io,
              output d_clk,
              output data_out,
              output reg [3:0] LED );
                  
reg [7:0] rtc_write_add   = 8'b1101000_0; // write
reg [7:0] rtc_pointer_add = 8'b0000_0000; // pointer address 
reg [26:0] seconds_counter;
reg [4:0] second_value;
reg [7:0] sec = 8'b0000_0000; // Seconds 
reg [7:0] min = 8'h00; // Minutes
reg [7:0] hrs = 8'h16; // Hour

reg [7:0] day   = 8'h03; // Wednesday - Day
reg [7:0] date  = 8'h08; // 8th - Date
reg [7:0] month = 8'h07; // July - Month
reg [7:0] year  = 8'h26; // 2026 - Year

wire [7:0] segment_4;
wire [7:0] segment_3;
wire [7:0] segment_2;
wire [7:0] segment_1;



reg time_ready;
  
reg [3:0] rtc_counter;
reg [7:0] rtc_data;
reg [7:0] uart_data;
wire[7:0] rx_data;
wire data_valid;
reg repeat_sequence;
reg i2c_start;
reg receive;
reg ReadWrite;

// READ from RTC
reg [7:0] rx_sec;
reg [7:0] rx_min;
reg [7:0] rx_hrs;

reg [7:0] rx_day;
reg [7:0] rx_date;
reg [7:0] rx_month;
reg [7:0] rx_year;
reg i2c_done;
reg  [1:0] rtc_state;
reg uart_done = 1'b0;
wire tx_valid;
wire [2:0] state;
wire [2:0]global_counter;
wire [7:0]input_data1;
parameter
         IDLE  = 2'b00,
         WRITE = 2'B01,
         READ  = 2'b10,
         LOOP  = 2'b11;

Main uut (clk,rst,i2c_start,ReadWrite,rtc_data,sda, data_valid, state , scl,rx_data, uart_done, rx_hrs, rx_min, rx_sec, data_out);
TM1637_Controller uu2t (clk,rst,uart_done,d_io,d_clk,segment_4,segment_3, segment_2,segment_1);
ila_0   uu3t (clk,uart_done,state,rtc_counter,rx_hrs ,global_counter , input_data1 );

Number_set uut1 (rx_min [7:4], segment_4);
Number_set uut2 (rx_min [3:0],segment_3);

//Number_set uut3 ({2'b00 , rx_hrs [5:4]}, segment_2);
//Number_set uut4 (rx_hrs [3:0], segment_1);

Number_set uut3 (rx_sec [7:4], segment_2);
Number_set uut4 (rx_sec [3:0], segment_1);

always @(posedge clk)
begin
     if(~rst)
     begin
          i2c_start       <= 0;
          i2c_done        <= 0;
          repeat_sequence <= 0;
          receive         <= 0;
          rtc_counter     <= 0;
          rtc_state       <= IDLE;                
          ReadWrite       <= 0;
          rx_sec          <= 0;
          rx_min          <= 0;
          rx_hrs          <= 0;
          rx_day          <= 0;
          rx_date         <= 0;
          rx_month        <= 0;
          rx_year         <= 0;
          seconds_counter <= 0;
          LED             <= 4'b0001;
          second_value    <= 0;
          time_ready      <= 0;
     end
     
     else
     begin
          if(seconds_counter < 27'd125_000_000)
          begin
            seconds_counter <= seconds_counter + 1'd1;
            uart_done       <= 0;
          end
          else if(seconds_counter == 27'd125_000_000)
          begin
            seconds_counter <= 0;
            uart_done       <= 1;
            second_value    <= second_value + 1'd1;  
          
               if (time_ready)
               begin
                    uart_done  <= 1; 
               end
               
               else 
               begin
                    uart_done  <= 0; 
               end
          end
          
               
            
          case(rtc_state)
                    IDLE:
                    begin
                         if(RW_start)
                         begin
                              receive         <= 0;
                              repeat_sequence <= 1;
                              rtc_state       <= WRITE;   
                         end
                         
                         else
                         begin
                               receive         <= 1;
                               repeat_sequence <= 1;
                               rtc_state       <= READ;
                         end
                    end
                    
                    WRITE:
                    begin
                         if(~receive && repeat_sequence)
                         begin
                              if(rtc_counter == 0)
                              begin
                                   i2c_start    <=  1;
                                   ReadWrite    <= 0; // Writing
                                   rtc_data     <=  rtc_write_add;
                                   rtc_counter  <=  rtc_counter + 1;
                                   LED          <= 4'b0111;
                              end
					          
					          else if(rtc_counter == 1 && data_valid)
					          begin	
							       rtc_data     <= rtc_pointer_add;
							       rtc_counter  <= rtc_counter + 1;
							       
					          end 
                              
                              else if(rtc_counter == 2 && data_valid)
					          begin	
							       rtc_data     <= sec;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 3 && data_valid)
					          begin	
							       rtc_data     <= min;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 4 && data_valid)
					          begin	
							       rtc_data     <= hrs;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 5 && data_valid)
					          begin	
							       rtc_data     <= day;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 6 && data_valid)
					          begin	
							       rtc_data     <= date;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 7 && data_valid)
					          begin	
							       rtc_data     <= month;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 8 && data_valid)
					          begin	
							       rtc_data     <= year;
							       rtc_counter  <= rtc_counter + 1;
					          end
					          
					          else if(rtc_counter == 9 && data_valid)
					          begin	
							       rtc_counter  <= rtc_counter + 1;
							       i2c_done     <= 1;
							       i2c_start    <= 0;
							  end
							  else if(rtc_counter == 10 && state == 0)
							  begin
							     rtc_state    <= READ;
							     rtc_counter  <= 0;
							     receive      <= 1;
					          end
                         end
                    end
                    
                    READ:
                    begin
                         if(receive && repeat_sequence)
                         begin
                              if (rtc_counter == 0)
                              begin
                                   i2c_start   <= 1;
                                   i2c_done    <= 0;
                                   ReadWrite   <= 0; // Device Address Write
                                   rtc_data    <= rtc_write_add;
                                   rtc_counter <= rtc_counter + 1;                              
                              end
                         
                          else if(rtc_counter == 1 && data_valid) 
                          begin
                               i2c_start       <= 0;
                               rtc_data        <= rtc_pointer_add; 
                               rtc_counter     <= rtc_counter + 1;
                          end
                          else if (rtc_counter == 2 && data_valid) 
                          begin
                               i2c_start       <= 1;
                               rtc_data        <= {rtc_write_add[7:1], 1'b1};
                               rtc_counter     <= rtc_counter + 1;
                          end
                          else if (rtc_counter == 3 && state == 3'b010) 
                          begin
                               ReadWrite       <= 1;                 
                               rtc_counter     <= rtc_counter + 1;
                          end

                          else if (rtc_counter == 4 && data_valid) 
						  begin
							    rtc_counter 	<= rtc_counter + 1;
							    
						  end
                          else if (rtc_counter == 5 && data_valid) 
                          begin
                               rx_sec          <= rx_data;
                               rtc_counter     <= rtc_counter + 1;  
                          end
                          else if (rtc_counter == 6 && data_valid) 
                          begin
                               rx_min          <= rx_data;
                               rtc_counter     <= rtc_counter + 1;
                          end
                          else if(rtc_counter == 7 && data_valid)
                          begin
                                rx_hrs         <= rx_data;
                               i2c_start       <= 0; 
                               rtc_counter     <= rtc_counter + 1;
                               time_ready      <= 1;
                          end
                          else if (rtc_counter == 8 && state == 3'b000) 
                          begin
                               rtc_counter     <= 0;
                               i2c_done        <= 1;
                               ReadWrite	   <= 0;
							   repeat_sequence <= 1;
                               rtc_state       <= LOOP;
						       LED             <= 4'b1111;                        
                          end
                         end    
                    end
                    
                    LOOP:
                    begin
                              receive         <= 1;
                              repeat_sequence <= 1;
                              rtc_state       <= READ;
                    end
          endcase
     end
end     
endmodule

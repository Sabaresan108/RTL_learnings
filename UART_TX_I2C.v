module UART_TX( input clk , rst , start,
                input [7:0] hrs_data,
                input [7:0] min_data,
                input [7:0] sec_data,
                output reg data_out, 
                output reg tx_valid,
                output reg  [4:0]global_counter,
                output     input_data1 );

parameter
    IDLE  =  2'b00,
    START =  2'b01,
    STOP  =  2'b10;
reg [1:0] state;
reg [3:0] data_counter;
reg [7:0] input_data;
reg [11:0] baud_counter; 

always@(posedge clk)
begin
    if(~rst)
    begin
        state           <= IDLE;
        data_counter    <= 0;
        input_data      <= 0;     
        baud_counter    <= 0;
        global_counter  <= 0;
        data_out        <= 1;
        tx_valid        <= 0;
    end
    else
    begin
        case(state)
            IDLE:
            begin
                tx_valid <= 0;
                if(start)
                begin                 
                        data_out <= 1;
                        input_data <= {4'b0000, hrs_data[7:4]} + 8'h30;
                        state <= START;
                    end
                end     
            START:
            begin
                if(data_counter == 0)
                begin
                    if(baud_counter  < 11'd1084)
                    begin
                        data_out <= 0;  
                        baud_counter <= baud_counter + 1;
                    end
                    else
                    begin
                        baud_counter <= 0;
                        data_counter <= data_counter + 1;
                    end
                end
                else if(data_counter < 4'd9)     
                begin
                    if(baud_counter  < 11'd1084)
                    begin
                            data_out <= input_data[0];
                            baud_counter <= baud_counter + 1;
                    end
                    else if(baud_counter == 11'd1084)
                    begin
                            input_data <= input_data >> 1;
                            data_counter <= data_counter + 1;
                            baud_counter <= 0;
                    end
                end
                else
                begin
                        data_counter <= 0;
                        state <= STOP;
                end
                    
            end
            
            STOP:
            begin
                if(baud_counter < 11'd1084 )
                begin               
                    data_out <= 1;
                    baud_counter <= baud_counter + 1;
                end
                else
                begin
                    
                    baud_counter <= 0;
                    
                    if(global_counter == 4'd8)
                    begin
                        state          <= IDLE;
                        tx_valid       <= 1;
                        global_counter <= 0;
                    end
                    else
                    begin
                        global_counter <= global_counter + 1'b1;
                        state          <= START;
                        
                        // Muxing the next ASCII character to be transmitted
                        case(global_counter)
                            4'd0: input_data <= {4'b0000, hrs_data[3:0]} + 8'h30; // Hours Ones
                            4'd1: input_data <= 8'h3A;
                            4'd2: input_data <= {4'b0000, min_data[7:4]} + 8'h30; // Minutes Tens
                            4'd3: input_data <= {4'b0000, min_data[3:0]} + 8'h30; // Minutes Ones
                            4'd4: input_data <= 8'h3A;
                            4'd5: input_data <= {4'b0000, sec_data[7:4]} + 8'h30; // Seconds Tens
                            4'd6: input_data <= {4'b0000, sec_data[3:0]} + 8'h30; // Seconds Ones
                            4'd7: input_data <= 8'h0D;                            // Carriage Return (\r)
                            4'd8: input_data <= 8'h0A;
                            default: input_data <= 8'h30;
                        endcase
                    end
                end
            end
       endcase
   end
end
assign input_data1 = input_data;
endmodule

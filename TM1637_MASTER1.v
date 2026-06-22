module TM1637_MASTER1(input clk,rst, start, cmd1 ,
                      input [7:0] data_in,
                      input stop,
                      inout d_io,
                      output ready,
                      output reg data_valid,
                      output reg d_clk);

reg [11:0] count;
reg [3:0] counter;
reg [7:0] tx_data;
reg [1:0] state;
reg enable;
reg d_out;
reg stop_tx;

parameter 
          IDLE  = 2'b00,
          START = 2'b01,
          ACK   = 2'b10,
          STOP  = 2'b11;

assign d_io = enable ? d_out : 1'bz;

assign ready = (state == IDLE); 

always @ (posedge clk)
begin
    if(~rst)
    begin
        state      <= IDLE;
        tx_data    <= 0;
        counter    <= 0;
        count      <= 0;
        stop_tx    <= 0;
        data_valid <= 0;
        d_clk      <= 1;
        d_out      <= 1;
        enable     <= 1;          
    end
    else
    begin
        data_valid <= 0;
        
        if (count == 313 && d_clk == 0)
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
        
        case(state)
            IDLE:
            begin 
                d_clk  <= 1;
                enable <= 1;
                d_out  <= 1;
                
                if(start)
                begin
                    tx_data <= data_in;
                    stop_tx <= 0;
                    state   <= START;
                    counter <= 0;
                    d_out   <= 0; 
                end
            end
            
            START:
            begin
                if (counter < 4'd8)
                begin
                    if (count == 0 && d_clk == 0)
                    begin
                        enable <= 1;
                        d_out   <= tx_data[counter];
                        counter <= counter + 1;                        
                    end
                end
                else
                begin
                    if (count == 0 && d_clk == 0)
                    begin
                        enable  <= 0; // FOR ACK
                        counter <= 0;
                        state   <= ACK;
                    end
                end
            end
            
            ACK:
            begin
                if (count == 150 && d_clk == 1)
                begin
                     if (~d_io)
                     begin
                        enable <= 1; 
                    end
                end
                else if(enable && count == 312)
                begin
                    if(cmd1) 
                    begin
                        state <= STOP;
                    end
                    else 
                    begin
                        state   <= START;
                    end 
                 end
             end
            
            STOP:
            begin
                if (count == 50 && d_clk == 1)
                begin
                    d_out <= 1;
                end
                else if(count == 200 && d_clk == 1)
                begin
                    state <= IDLE;
                    data_valid <= 1;
                end
            end 
        endcase
    end            
end
endmodule

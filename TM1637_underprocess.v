module TM1637_MASTER1(
    input clk,
    input rst, 
    input start,
    input [7:0] data_in,
    inout d_io,
    output ready,      // <--- Perfectly placed!
    output reg d_clk
);

reg [11:0] count;
reg [3:0] counter;
reg [7:0] tx_data;
reg [1:0] state;
reg enable;
reg d_out;

parameter IDLE  = 2'b00,
          START = 2'b01,
          ACK   = 2'b10,
          STOP  = 2'b11;

// Tri-state buffer control
assign d_io = enable ? d_out : 1'bz;

// Tell the controller when we are free!
assign ready = (state == IDLE); 

always @ (posedge clk)
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
    else
    begin
        // --- Clock Division Part ---
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
        // ---------------------------
        
        // --- State Machine ---
        case(state)
            IDLE:
            begin
                d_clk  <= 1;
                enable <= 1;
                d_out  <= 1;
                
                if(start)
                begin
                    tx_data <= data_in;
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
                        d_out   <= tx_data[counter];
                        counter <= counter + 1;                        
                    end
                end
                else
                begin
                    if (count == 0 && d_clk == 0)
                    begin
                        enable  <= 0; 
                        counter <= 0;
                        state   <= ACK;
                    end
                end
            end
            
            ACK:
            begin
                if (count == 150 && d_clk == 1)
                begin
                    if(d_io == 0) 
                    begin
                        state <= STOP; 
                    end
                    else
                    begin
                        state <= STOP; 
                    end
                end
            end
            
            STOP:
            begin
                if (count == 0 && d_clk == 0)
                begin
                    enable <= 1; 
                    d_out  <= 0;
                end
                else if (count == 150 && d_clk == 1)
                begin
                    d_out <= 1; 
                end
                else if (count == 300 && d_clk == 1)
                begin
                    state <= IDLE;
                end
            end 
        endcase
    end            
end
endmodule

module TM1637_Controller (input clk,rst, start_tm ,
                          inout d_io,
                          output d_clk,
                          input [7:0] segment_4,
                          input [7:0] segment_3,
                          input [7:0] segment_2,
                          input [7:0] segment_1);
 
reg [26:0] count_sec; 
reg [7:0] data_in;
reg [1:0] state;
reg [13:0] sec;
reg [3:0] step;
reg sec_over;
reg stop_tx;
reg start;
reg cmd1;

wire data_valid;
wire ready;
wire d_in1;
wire [1:0] state1;
wire d_out1;

TM1637_master uut (clk ,rst ,start ,cmd1 ,data_in ,stop_tx ,d_io ,ready ,data_valid ,d_clk , state1 , d_out1 , d_in1);
Number_set uut5 (hex_value, data);

parameter
    IDLE  = 2'b00,
    START = 2'b01,
    WAIT  = 2'b10;

always @(posedge clk)
begin
    if (~rst)
    begin
         state   <= IDLE;
         start   <= 0;
         data_in <= 0;
         step    <= 0;
         stop_tx <= 0;
         cmd1    <= 1;
 
    end
 
    else 
    begin
    
         case (state)
              IDLE:
              begin
                   if (start_tm)
                   begin
                        step  <= 1;
                        state <= START;
                   end
              end
 
              START:
              begin
                   if (step == 1) // Cmd 1: Instruction
                   begin
                         start   <= 1;
                         data_in <= 8'h40;  // write value
                         stop_tx <= 0;
                   end
 
                   else if (step == 2) // Cmd 2: Address
                   begin
                        start   <= 1;
                        data_in <= segment_4; //  Digit 1
                        stop_tx <= 1;
                        cmd1    <= 0;
                   end
 
                   else if (step == 3) // Cmd 3: DATA
                   begin
                        start   <= 1;
                        data_in <= segment_3|8'h80; // Digit 2
                        stop_tx <= 0;
                        cmd1    <= 0;
                   end
 
                   else if (step == 4) // Cmd 3: DATA
                   begin
                        start   <= 1;
                        data_in <= segment_2; // Digit 3
                        stop_tx <= 0;
                        cmd1    <= 0;
                   end
 
                   else if (step == 5) // Cmd 3: DATA
                   begin
                        start <= 1;
                        data_in <=segment_1 ; // Digit 4
                        stop_tx <= 0;
                        cmd1    <= 0;
                   end
 
                   else if (step == 6) // Cmd 3: DATA
                   begin
                        start   <= 1;
                        data_in <= 8'h69; // Digit 3
                        stop_tx <= 0;
                        cmd1    <= 0;
                   end
 
                   else if (step == 7) // Cmd 3: DATA
                   begin
                        start   <= 1;
                        data_in <= 8'h96; // Digit 4
                        stop_tx <= 0;
                        cmd1    <= 0;
                   end
 
                   else if (step == 8) // Cmd 4: Turn Display ON
                   begin
                        start   <= 1;
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
                        if (step == 8)
                        begin
                             step  <= 1;
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

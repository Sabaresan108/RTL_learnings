module DAC(input clk, rst,sw,
	       inout sda,
	       output scl,
           output reg [3:0] led);
           
reg [7:0]  address     = 8'b1100_0010; // C2 (A0 tied to VDD)
reg        ReadWrite   = 1'b0;         // 0 = Write, 1 = Read
reg [7:0]  cmd         = 8'b0100_0000; // 0x40 (Write DAC Register Mode)
reg [15:0] dac_data_1  = 16'b1111_1111_1111_0000; // Full Voltage (3.3V)
reg [15:0] dac_data_2  = 16'b0000_0000_0000_0000; // Zero Voltage (0V)

reg start;
wire data_valid;
reg [2:0] byte_count;
reg [7:0] data;

reg sw_prev;
reg start_request;
reg i2c_done;

wire dbg_start;
wire sda_listener;
wire sdainput_ila, sdaoutput_ila;
wire enable;
wire [2:0] state1;
wire [3:0] data_counter1;
wire [3:0] led1;
wire [8:0] i2c_counter_debug;

assign dbg_start = start;

I2C_Master uut (clk, rst, start, ReadWrite, data, sda, scl, sdainput_ila, sdaoutput_ila, enable, data_valid, led1, state1, data_counter1, sda_listener, i2c_counter_debug);

ila_0 uut1 (clk, enable, data_valid, scl, byte_count, sda_listener, state1, data_counter1, start, i2c_counter_debug);

always @(posedge clk) 
begin
    if (~rst) 
    begin
       	 start         <= 0;
         byte_count    <= 0;
         i2c_done      <= 0;
         led           <= 4'b0000;
         sw_prev       <= sw; 
         start_request <= 0;
    end

    else 
    begin
         if (sw != sw_prev && byte_count == 0 && !start_request) 
	     begin
              sw_prev       <= sw;
              start_request <= 1;
         end
        
        else if (byte_count == 0 && start_request) 
	    begin
            start         <= 1;
            data          <= address;
            byte_count    <= 1;
            start_request <= 0;
            i2c_done      <= 0;
//            led           <= 4'b0001;
        end
        
        
        else if (data_valid) 
	    begin
              byte_count <= byte_count + 1;
            
             if (byte_count == 1) 
	         begin
             	  data <= cmd;
//                  led  <= 4'b1101;
             end
            
            else if (byte_count == 2) 
	        begin
                 if (sw) 
		         begin
                      data <= dac_data_1[15:8];
                      led  <= 4'b1111;
                 end

                 else 
		         begin
                      data <= dac_data_2[15:8];
                 end
            end
            
            else if (byte_count == 3) 
 	        begin
                 if (sw) 
		         begin
                      data <= dac_data_1[7:0];
                      led  <= 4'b0001;

                 end
                 else 
		         begin
                      data <= dac_data_2[7:0];
                      led  <= 4'b1111;                      
                 end
            end 
            
            else if (byte_count == 4) 
	        begin 
                 start      <= 0;
                 byte_count <= 0;  
                 i2c_done   <= 1;
            end
         end
           else 
           begin
                i2c_done <= 0;
            end
      end
end

endmodule

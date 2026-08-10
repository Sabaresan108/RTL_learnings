module DAC_sine_wave (input clk, rst,
                      input [2:0] btn,
                      inout sda,
                      output scl,
                      output reg [3:0] led);
           
reg [7:0]  address     = 8'b1100_0010; // C2 (A0 tied to VDD)
reg        ReadWrite   = 1'b0;         // 0 = Write, 1 = Read

parameter Hertz_50 = 32'd17857; // Sample = 140 (140 x 50 = 7000 HZ)

reg start;
wire data_valid;
reg [2:0] byte_count;
reg [7:0] data;
reg start_request;
reg [31:0] time_count;
reg [31:0] limit;
reg i2c_done;

reg [7:0] lut_index_prev;
reg [7:0]  lut_index;
reg [11:0] dac_value;
reg [11:0] sine_lut [0:139];  


initial
begin
     // Quarter 1 - Midpoint to Positive Peak (0 to 90 degrees) - (1.65V to 3.3V)
    sine_lut[0]  = 12'd2048; sine_lut[1]  = 12'd2140; sine_lut[2]  = 12'd2231; sine_lut[3]  = 12'd2322;
    sine_lut[4]  = 12'd2412; sine_lut[5]  = 12'd2501; sine_lut[6]  = 12'd2589; sine_lut[7]  = 12'd2675;
    sine_lut[8]  = 12'd2760; sine_lut[9]  = 12'd2843; sine_lut[10] = 12'd2924; sine_lut[11] = 12'd3003;
    sine_lut[12] = 12'd3079; sine_lut[13] = 12'd3153; sine_lut[14] = 12'd3224; sine_lut[15] = 12'd3293;
    sine_lut[16] = 12'd3359; sine_lut[17] = 12'd3422; sine_lut[18] = 12'd3482; sine_lut[19] = 12'd3539;
    sine_lut[20] = 12'd3593; sine_lut[21] = 12'd3644; sine_lut[22] = 12'd3691; sine_lut[23] = 12'd3735;
    sine_lut[24] = 12'd3776; sine_lut[25] = 12'd3813; sine_lut[26] = 12'd3846; sine_lut[27] = 12'd3876;
    sine_lut[28] = 12'd3902; sine_lut[29] = 12'd3925; sine_lut[30] = 12'd3944; sine_lut[31] = 12'd3959;
    sine_lut[32] = 12'd3970; sine_lut[33] = 12'd3978; sine_lut[34] = 12'd3982;

    // Quarter 2 - Positive Peak to Midpoint (90 to 180 degrees) - (3.3V to 1.65V)
    sine_lut[35] = 12'd4095; sine_lut[36] = 12'd3982; sine_lut[37] = 12'd3978; sine_lut[38] = 12'd3970;
    sine_lut[39] = 12'd3959; sine_lut[40] = 12'd3944; sine_lut[41] = 12'd3925; sine_lut[42] = 12'd3902;
    sine_lut[43] = 12'd3876; sine_lut[44] = 12'd3846; sine_lut[45] = 12'd3813; sine_lut[46] = 12'd3776;
    sine_lut[47] = 12'd3735; sine_lut[48] = 12'd3691; sine_lut[49] = 12'd3644; sine_lut[50] = 12'd3593;
    sine_lut[51] = 12'd3539; sine_lut[52] = 12'd3482; sine_lut[53] = 12'd3422; sine_lut[54] = 12'd3359;
    sine_lut[55] = 12'd3293; sine_lut[56] = 12'd3224; sine_lut[57] = 12'd3153; sine_lut[58] = 12'd3079;
    sine_lut[59] = 12'd3003; sine_lut[60] = 12'd2924; sine_lut[61] = 12'd2843; sine_lut[62] = 12'd2760;
    sine_lut[63] = 12'd2675; sine_lut[64] = 12'd2589; sine_lut[65] = 12'd2501; sine_lut[66] = 12'd2412;
    sine_lut[67] = 12'd2322; sine_lut[68] = 12'd2231; sine_lut[69] = 12'd2140;

    // Quarter 3 - Midpoint to Negative Peak (180 to 270 degrees) - (1.65V to 0V)
    sine_lut[70] = 12'd2048; sine_lut[71] = 12'd1956; sine_lut[72] = 12'd1865; sine_lut[73] = 12'd1774;
    sine_lut[74] = 12'd1684; sine_lut[75] = 12'd1595; sine_lut[76] = 12'd1507; sine_lut[77] = 12'd1421;
    sine_lut[78] = 12'd1336; sine_lut[79] = 12'd1253; sine_lut[80] = 12'd1172; sine_lut[81] = 12'd1093;
    sine_lut[82] = 12'd1017; sine_lut[83] = 12'd943;  sine_lut[84] = 12'd872;  sine_lut[85] = 12'd803;
    sine_lut[86] = 12'd737;  sine_lut[87] = 12'd674;  sine_lut[88] = 12'd614;  sine_lut[89] = 12'd557;
    sine_lut[90] = 12'd503;  sine_lut[91] = 12'd452;  sine_lut[92] = 12'd405;  sine_lut[93] = 12'd361;
    sine_lut[94] = 12'd320;  sine_lut[95] = 12'd283;  sine_lut[96] = 12'd250;  sine_lut[97] = 12'd220;
    sine_lut[98] = 12'd194;  sine_lut[99] = 12'd171;  sine_lut[100]= 12'd152;  sine_lut[101]= 12'd137;
    sine_lut[102]= 12'd126;  sine_lut[103]= 12'd118;  sine_lut[104]= 12'd114;

    // Quarter 4 - Negative Peak to Midpoint (270 to 360 degrees) - (0V to 1.65V)
    sine_lut[105]= 12'd1;    sine_lut[106]= 12'd114;  sine_lut[107]= 12'd118;  sine_lut[108]= 12'd126;
    sine_lut[109]= 12'd137;  sine_lut[110]= 12'd152;  sine_lut[111]= 12'd171;  sine_lut[112]= 12'd194;
    sine_lut[113]= 12'd220;  sine_lut[114]= 12'd250;  sine_lut[115]= 12'd283;  sine_lut[116]= 12'd320;
    sine_lut[117]= 12'd361;  sine_lut[118]= 12'd405;  sine_lut[119]= 12'd452;  sine_lut[120]= 12'd503;
    sine_lut[121]= 12'd557;  sine_lut[122]= 12'd614;  sine_lut[123]= 12'd674;  sine_lut[124]= 12'd737;
    sine_lut[125]= 12'd803;  sine_lut[126]= 12'd872;  sine_lut[127]= 12'd943;  sine_lut[128]= 12'd1017;
    sine_lut[129]= 12'd1093; sine_lut[130]= 12'd1172; sine_lut[131]= 12'd1253; sine_lut[132]= 12'd1336;
    sine_lut[133]= 12'd1421; sine_lut[134]= 12'd1507; sine_lut[135]= 12'd1595; sine_lut[136]= 12'd1684;
    sine_lut[137]= 12'd1774; sine_lut[138]= 12'd1865; sine_lut[139]= 12'd1956;

end

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

//vio uut2 (clk, lut_index, freq_sel);

always @(posedge clk) 
begin
    if (~rst) 
    begin
       	 start          <= 0;
         byte_count     <= 0;
         i2c_done       <= 0;
         start_request  <= 0;
         time_count     <= 0;
         lut_index      <= 0;
         limit          <= 0;
         lut_index_prev <= 8'd139;
         dac_value      <= 12'd2048;
         led            <= 4'b1111;
    end

    else 
    begin
         if (btn[0])
         begin  
           limit <= Hertz_50;   // 50HZ (20ms)
         end
         else if (btn[1])
         begin
              limit <= 0;
         end         
         
         if (limit != 0)
         begin
               if (time_count >= limit - 1)
               begin
                    time_count <= 0;
                    
                    if (lut_index >= 8'd139)
                    begin
                        lut_index <= 0;
                    end
                    
                    else
                    begin
                        lut_index <= lut_index + 1;
                    end
               end
               
               else
               begin
                    time_count <= time_count + 1;
               end
         end
         
         else
         begin
              time_count <= 0;
              lut_index   <= 0;
         end
    
        if (lut_index != lut_index_prev && byte_count == 0 && !start_request) 
        begin
             lut_index_prev <= lut_index;
             dac_value <= sine_lut[lut_index];
             start_request <= 1;
        end
        
        else if (byte_count == 0 && start_request) 
	    begin
            start         <= 1;
            data          <= address;
            byte_count    <= 1;
            start_request <= 0;
            i2c_done      <= 0;
        end
        
        else if (data_valid) 
	    begin
              byte_count <= byte_count + 1;
            
             if (byte_count == 1) 
	         begin
             	  data <= {2'b00, dac_value[11:8]};  // PD1,PD0=00 + D11-D8
                  led  <= dac_value[11:8];;
             end
            
            else if (byte_count == 2) 
	        begin
                 data <= dac_value[7:0];            // D7-D0
            end
            
            else if (byte_count == 3) 
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

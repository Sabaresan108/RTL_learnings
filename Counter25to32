module counter0_32 (
    input clk, rst,
    output reg [5:0] count,   // 6-bit to support up to 32
    output reg Green,
    output reg Red
);

always @(posedge clk)
begin
    if (!rst)
    begin
        count <= 0;
        Green <= 0;
        Red <= 0;
    end
    else
    begin
        count <= count + 1;

        // Default OFF
        Green <= 0;
        Red <= 0;

        if (count == 6'd25)
        begin
            Green <= 1;
        end
        else if (count == 6'd32)
        begin
            Red <= 1;
        end
    end
end

endmodule

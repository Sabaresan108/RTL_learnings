module counter0_32 (
    input clk,
    input rst,
    input entry_sensor,
    input exit_sensor,
    output reg [5:0] count,
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
        // Entry condition
        if (entry_sensor && count < 32)
            count <= count + 1;

        // Exit condition
        else if (exit_sensor && count > 0)
            count <= count - 1;

        // LED logic (default OFF)
        Green <= 0;
        Red <= 0;

        if (count == 6'd25)
            Green <= 1;

        if (count == 6'd32)
            Red <= 1;
    end
end

endmodule

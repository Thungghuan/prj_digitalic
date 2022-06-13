module module_divider(dividend, divisor, quotient);

parameter DATAWIDTH = 24;

input [DATAWIDTH - 1:0] dividend;
input [DATAWIDTH - 1:0] divisor;

output reg [DATAWIDTH - 1:0] quotient;

reg [DATAWIDTH - 1:0] tempa;
reg [DATAWIDTH - 1:0] tempb;
reg [2 * DATAWIDTH - 1:0] temp_a;
reg [2 * DATAWIDTH - 1:0] temp_b;

integer i;

always @(dividend or divisor)
begin
    tempa <= dividend;
    tempb <= divisor;
end

always @(tempa or tempb)
begin
    temp_a = {{DATAWIDTH{1'b0}}, tempa};
    temp_b = {tempb, {DATAWIDTH{1'b0}}};

    for(i = 0; i < DATAWIDTH; i = i + 1)
    begin
        temp_a = temp_a << 1;
        if (temp_a >= temp_b)
            temp_a = temp_a - temp_b + 1'b1;
        else
            temp_a = temp_a;
    end

    quotient = temp_a[DATAWIDTH - 1:0];
end

endmodule

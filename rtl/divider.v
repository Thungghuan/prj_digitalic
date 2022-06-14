module divider_step(
    clk,
    dividend,
    divisor,
    quotient_last,
    result_shift_last,

    quotient,
    remainder,
    result_shift
);

parameter step = 0;
parameter M = 26; // bit number of dividend
parameter N = 14; // bit number of divisor

input clk;
input [N:0] dividend;
input [N - 1:0] divisor;
input [M - 1:0] quotient_last;
input [N:0] result_shift_last;

output reg [M - 1:0] quotient;
output reg [N - 1:0] remainder;
output reg [N:0] result_shift;

reg [N:0] count = 0;
reg [N:0] divisor_t;
reg overflow = 0;

always @(posedge clk) begin
    divisor_t = {1'b0, divisor};
    count = 0;

    // quotient to be 1
    if (dividend >= divisor) begin
        while (dividend >= divisor_t) begin
        // while (dividend - divisor_t >= 1) begin
            count = count + 1;
            divisor_t = divisor_t << 1;
        end

        divisor_t = divisor_t >> 1;
        count = count - 1;

        quotient <= (quotient_last << 1) + (1 << count);
        remainder <= dividend - divisor_t;

    end
    // quotient to be 0
    else begin
        quotient <= quotient_last << 1;
        remainder <= dividend;
    end

    if (step == 0)
        result_shift <= count;
    else
        result_shift <= result_shift_last;
end

endmodule

module divider(clk, dividend, divisor, quotient);

parameter M = 26; // bit number of dividend
parameter N = 14; // bit number of divisor

input clk;
input [M - 1:0] dividend;
input [N - 1:0] divisor;
output [M - 1:0] quotient;

wire [N:0] result_shifts [M - N - 1:0];
wire [M - 1:0] quotients [M - N - 1:0];
wire [N - 1:0] remainders [M - N - 1:0];

divider_step step_0(
    .clk(clk),
    .dividend(dividend[M - 1:M - N - 1]),
    .divisor(divisor),
    .quotient_last({M{1'b0}}),
    .result_shift_last({(N + 1){1'b0}}),

    .quotient(quotients[M - N - 1]),
    .remainder(remainders[M - N - 1]),
    .result_shift(result_shifts[M - N - 1])
);

genvar i;
generate
    for (i = 1; i <= M - N - 1; i = i + 1) begin
        divider_step #(i)
        step_i 
        (
            .clk(clk),
            .dividend({remainders[M - N - i], dividend[M - N - i]}),
            .divisor(divisor),
            .quotient_last(quotients[M - N - i]),
            .result_shift_last(result_shifts[M - N - i]),

            .quotient(quotients[M - N - 1 - i]),
            .remainder(remainders[M - N - 1 - i]),
            .result_shift(result_shifts[M - N - 1 - i])
        );
    end
endgenerate

assign quotient = quotients[0];

endmodule

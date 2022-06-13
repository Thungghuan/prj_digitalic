module divider_step(
    clk,
    dividend,
    divisor,
    quotient_last,

    quotient,
    remainder
);

parameter M = 26; // bit number of dividend
parameter N = 14; // bit number of divisor

input clk;
input [N:0] dividend;
input [N - 1:0] divisor;
input [M - 1:0] quotient_last;

output reg [M - 1:0] quotient;
output reg [N - 1:0] remainder;

always @(posedge clk) begin
    // quotient to be 1
    if (dividend >= {1'b0, divisor}) begin
        quotient <= (quotient_last << 1) + 1'b1;
        remainder <= dividend - {1'b0, divisor};
    end
    // quotient to be 0
    else begin
        quotient <= quotient_last << 1;
        remainder <= dividend;
    end
end

endmodule

module divider(clk, dividend, divisor, quotient);

parameter M = 26; // bit number of dividend
parameter N = 14; // bit number of divisor

input clk;
input [M - 1:0] dividend;
input [N - 1:0] divisor;
output [M - 1:0] quotient;

wire [N - 1:0] remainder;

divider_step step0(
    .clk(clk),
    .dividend(dividend[M - 1:M - N - 1]),
    .divisor(divisor),
    .quotient_last({M{1'b0}}),

    .quotient(quotient),
    .remainder(remainder)
);

endmodule

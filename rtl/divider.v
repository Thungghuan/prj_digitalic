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

input wire clk;
input wire [N:0] dividend;
input wire [N - 1:0] divisor;
input wire [M - 1:0] quotient_last;

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
        remainder <= dividend[N - 1:0];
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

wire [M - 1:0] quotients [M - 1:0];
wire [N - 1:0] remainders [M - 1:0];

divider_step step_0(
    .clk(clk),
    .dividend({{N{1'b0}}, dividend[M - 1]}),
    .divisor(divisor),
    .quotient_last({M{1'b0}}),

    .quotient(quotients[M - 1]),
    .remainder(remainders[M - 1])
);

genvar i;
generate
    for (i = 1; i <= M - 1; i = i + 1) begin : divide_step
        divider_step step_i 
        (
            .clk(clk),
            .dividend({remainders[M - i], dividend[M - i - 1]}),
            .divisor(divisor),
            .quotient_last(quotients[M - i]),

            .quotient(quotients[M - 1 - i]),
            .remainder(remainders[M - 1 - i])
        );
    end
endgenerate

assign quotient = quotients[0];

endmodule

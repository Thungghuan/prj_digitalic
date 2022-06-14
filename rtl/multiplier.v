module multiplier_step(
    clk,
    multi1,
    multi2,
    accu_last,

    multi1_shift,
    accu
);

parameter M = 26;
parameter N = 13;

input clk;
input [M + N- 1:0] multi1;
input multi2;
input [M + N - 1:0] accu_last;

output reg [M + N - 1:0] multi1_shift;
output reg [M + N - 1:0] accu;

always @(posedge clk) begin
    multi1_shift <= multi1 << 1;
    if (multi2)
        accu <= accu_last + multi1;
    else
        accu <= accu_last;
end

endmodule

module multiplier(
    clk,
    multi1,
    multi2,

    product
);

parameter M = 26; // bit numbers of output of the divider (unsingned)
parameter NS = 14; // bit numbers of output of the sin (signed)
parameter N = NS - 1;  // bit numbers of output of the sin (unsigned)

input clk;
input [M - 1:0] multi1;
input [NS - 1:0] multi2;

output [M + NS - 1:0] product;

wire sign;
assign sign = multi2[NS - 1];

wire [N - 1:0] us_multi2 = sign ? ~multi2[N - 1:0] + 1'b1 : multi2[N - 1:0];

wire [M + N - 1:0] accu [M - 1:0];
wire [M + N - 1:0] multi1_shift [M - 1:0];

multiplier_step step_0 (
    .clk(clk),
    .multi1({{N{1'b0}}, multi1}),
    .multi2(us_multi2[0]),
    .accu_last({(M + N){1'b0}}),

    .multi1_shift(multi1_shift[0]),
    .accu(accu[0])
);

genvar i;
generate
    for (i = 1; i <= M - 1; i = i + 1) begin : multi_block
        multiplier_step step_i(
            .clk(clk),
            .multi1(multi1_shift[i - 1]),
            .multi2(us_multi2[i]),
            .accu_last(accu[i - 1]),

            .multi1_shift(multi1_shift[i]),
            .accu(accu[i])
        );
    end
endgenerate

assign product = sign ? {sign, ~accu[M - 1] + 1'b1} : {sign, accu[M - 1]};

endmodule
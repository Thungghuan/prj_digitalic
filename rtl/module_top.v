module module_top(
    clk,
    a,
    b,
    c,
    e,

    y
);

input clk;

input [11:0] a;
input [11:0] b;
input [11:0] c;
input e;

output [13:0] y;

wire [25:0] dividend = {a, {14{1'b0}}};
wire [13:0] divisor;
assign divisor = a + b + c;

reg en;
wire divider_ok;

initial begin
    en = 1'b0;
    #8;
    en = 1'b1;
end

wire [25:0] out1;
divider mod_div(
    .clk(clk),
    .en(en),
    .dividend(dividend),
    .divisor(divisor),

    .quotient(out1),
    .divider_ok(divider_ok)
);

wire [9:0] d;
s2p mod_s2p(.clk(clk), .en(en), .dext(e), .dout(d));

wire sign;
wire [12:0] out2;
sin mod_sin(.sin_in(d), .sin_out(out2), .sign(sign));

reg mul_en = 1'b0;
always @(posedge divider_ok) begin
    mul_en <= 1'b1;
end

wire [38:0] out;
multiplier mod_mul(
    .clk(clk),
    .en(mul_en),
    .multi1(out1),
    .multi2(out2),

    .product(out)
);

assign y = sign ? {sign, ~out[12:0] + 1'b1} : {sign, out[12:0]};

endmodule


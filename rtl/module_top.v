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

output reg [11:0] y;

wire en;
assign en = a || b || c;

reg [11:0] a_in;
reg [11:0] b_in;
reg [11:0] c_in;
always @(posedge clk) begin
    a_in <= a;
    b_in <= b;
    c_in <= c;
end

wire [25:0] dividend = {a_in, {14{1'b0}}};
wire [13:0] divisor;
assign divisor = a_in + b_in + c_in;
wire divider_ok;

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

wire sign_t;
wire [12:0] out2;
sin mod_sin(.sin_in(d), .sin_out(out2), .sign(sign_t));

reg mul_en;
always @(posedge clk) begin
    if (divider_ok)
        mul_en <= 1'b1;
    else
        mul_en <= 1'b0;
end

wire mul_ok;
wire [38:0] out;
multiplier mod_mul(
    .clk(clk),
    .en(mul_en),
    .multi1(out1),
    .multi2(out2),

    .product(out),
    .multiplier_ok(mul_ok)
);

reg sign;
always @(posedge mul_ok) begin
    sign <= sign_t;
end

wire [11:0] y_out;
assign y_out = sign ? {sign, ~out[25:15] + 1'b1} : {sign, out[25:15]};

always @(posedge clk) begin
    y = y_out;
end


endmodule


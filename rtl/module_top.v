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

// output [23:0] y;
output [39:0] y;

wire [25:0] dividend = {a, {14{1'b0}}};
wire [13:0] divisor;
assign divisor = a + b + c;

reg en1;
wire divider_ok;

initial begin
    en1 = 1'b0;
    #8;
    en1 = 1'b1;
end

wire [25:0] out1;
divider mod_div(
    .clk(clk),
    .en(en1),
    .dividend(dividend),
    .divisor(divisor),
    .quotient(out1),
    .divider_ok(divider_ok)
);

wire [9:0] d;
s2p mod_s2p(.clk(clk), .dext(e), .dout(d));

wire [13:0] out2;
sin mod_sin(.sin_in(d), .sin_out(out2));

wire [39:0] out;
multiplier mod_mul(
    .clk(clk),
    .en(divider_ok),
    .multi1(out1),
    .multi2(out2),
    .product(out)
);

assign y = out;

endmodule


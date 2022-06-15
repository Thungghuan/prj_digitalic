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

wire [25:0] out1;
divider divider1(.clk(clk), .dividend(dividend), .divisor(divisor), .quotient(out1));

wire [9:0] d;
s2p s2p1(.clk(clk), .dext(e), .dout(d));

wire [13:0] out2;
sin sin1(.sin_in(d), .sin_out(out2));

wire [39:0] out;
multiplier multiplier1(.clk(clk), .multi1(out1), .multi2(out2), .product(out));

assign y = out;

endmodule


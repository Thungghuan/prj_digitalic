module module_digitalic(a, b, c, out);

input [11:0] a;
input [11:0] b;
input [11:0] c;

output [23:0] out;

//wire [13:0] sum;

//assign sum = a + b + c;
//assign out = sum;

//wire [23:0] dividend = {a, 12'b0};
// assign out = dividend;

//module_divider divider(dividend, dividend, out);
assign out = a + b + c;

endmodule


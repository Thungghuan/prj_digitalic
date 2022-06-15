module multiplier(
    clk,
    en,
    multi1,
    multi2,

    product
);

parameter M = 26; // bit numbers of output of the divider (unsingned)
parameter NS = 14; // bit numbers of output of the sin (signed)
parameter N = NS - 1;  // bit numbers of output of the sin (unsigned)

input clk, en;
input [M - 1:0] multi1;
input [NS - 1:0] multi2;

output reg [M + NS - 1:0] product;

wire sign;
assign sign = multi2[NS - 1];

wire [N - 1:0] us_multi2 = sign ? ~multi2[N - 1:0] + 1'b1 : multi2[N - 1:0];

reg [3:0] count;
always @(posedge clk) begin
    if (!en)
        count <= 0;
    else if (count == N)
        count <= 0;
    else
        count <= count + 1'b1;
end

reg [M + N - 1:0] multi1_t;
reg multi2_t;
reg [M + N - 1:0] product_t;

always @(posedge clk) begin
    if (!en) begin
        multi1_t <= {{N{1'b0}}, multi1};
        multi2_t <= us_multi2[0];
        product_t <= {(M + N){1'b0}};
    end
    else if (count == N) begin
        // product <= product_t;
        product <= sign ? {sign, ~product_t + 1'b1} : {sign, product_t};
    end
    else begin
        multi1_t <= multi1_t << 1;
        multi2_t <= us_multi2[1 + count];
        if (multi2_t)
            product_t <= product_t + multi1_t; 
    end
end

endmodule
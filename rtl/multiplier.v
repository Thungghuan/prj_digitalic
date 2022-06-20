module multiplier(
    clk,
    en,
    multi1,
    multi2,

    product,
    multiplier_ok
);

parameter M = 26; // bit numbers of output of the divider (unsingned)
parameter N = 13;  // bit numbers of output of the sin (unsigned)

input clk, en;
input [M - 1:0] multi1;
input [N - 1:0] multi2;

output reg [M + N - 1:0] product;
output reg multiplier_ok;

reg mul_en;

always @(posedge clk) begin
    mul_en <= en;
end

reg [3:0] count;
always @(posedge clk) begin
    if (!mul_en)
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
    if (!mul_en) begin
        multi1_t <= {{N{1'b0}}, multi1};
        multi2_t <= multi2[0];
        product_t <= {(M + N){1'b0}};
        multiplier_ok <= 0;
    end
    else begin
        if (count == N && !multiplier_ok) begin
            product <= product_t;
            multiplier_ok <= 1;
        end
        else begin
            multi1_t <= multi1_t << 1;
            multi2_t <= multi2[1 + count];
            if (multi2_t)
                product_t <= product_t + multi1_t; 
        end
    end 
end

endmodule

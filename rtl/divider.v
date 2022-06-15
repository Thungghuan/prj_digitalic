module divider(
    clk,
    en,
    dividend,
    divisor,

    divider_ok,
    quotient
);

parameter M = 26; // bit number of dividend
parameter N = 14; // bit number of divisor

input clk, en;
input [M - 1:0] dividend;
input [N - 1:0] divisor;

output reg [M - 1:0] quotient;
output reg divider_ok;

reg [N:0] dividend_t;
reg [M - 1:0] quotient_t;

reg [4:0] count;

always @(posedge clk) begin
    if (!en)
        count <= 0;
    else if (count == M)
        count <= 0;
    else
        count <= count + 1'b1; 
end

always @(posedge clk) begin
    if (!en) begin
        quotient <= 1'b0;
        divider_ok <= 1'b0;

        quotient_t <= {(M - 1){1'b0}};
        dividend_t <= {{N{1'b0}}, dividend[M - 1]};
    end
    else if (count == M) begin
        quotient <= quotient_t;
        divider_ok <= 1'b1;

        quotient_t <= {(M - 1){1'b0}};
        dividend_t <= {{N{1'b0}}, dividend[M - 1]};
    end
    else if (dividend_t >= {1'b0, divisor}) begin
        quotient_t <= {quotient_t[M - 2:0], 1'b1};
        dividend_t <= {dividend_t - {1'b0, divisor}, dividend[M - 2 - count]};
    end 
    else begin
        quotient_t <= {quotient_t[M - 2:0], 1'b0};
        dividend_t <= {dividend_t[N - 1:0], dividend[M - 2 - count]};
    end
end

endmodule

module multiplier(clk, multi1, multi2, product);

parameter DATAWIDTH = 14;

input clk;
input [DATAWIDTH - 1:0] multi1;
input [DATAWIDTH - 1:0] multi2;

output [2 * DATAWIDTH - 1:0] product;

// calculate counter
reg [31:0] cnt;
wire [31:0] cnt_temp = (cnt == DATAWIDTH) ? 1'b0 : cnt + 1'b1;

always @(posedge clk) begin
    if (cnt != DATAWIDTH)
        cnt <= cnt_temp;
    else
        cnt <= 1'b0;
end

// multiply operation
reg [2 * DATAWIDTH - 1:0] multi1_shift;
reg [DATAWIDTH - 1:0] multi2_shift;
reg [2 * DATAWIDTH - 1:0] multi_sum;

always @(posedge clk) begin
    if (cnt == 1'b0) begin
        multi1_shift <= {{DATAWIDTH{1'b0}}, multi1} << 1;  
        multi2_shift <= multi2 >> 1;  
        multi_sum <= multi2[0] ? {{DATAWIDTH{1'b0}}, multi1} : 1'b0;
    end
    else if (cnt != DATAWIDTH) begin
        multi1_shift <= multi1_shift << 1;
        multi2_shift <= multi2_shift >> 1;
        multi_sum <= multi2_shift[0] ? multi_sum + multi1_shift : multi_sum;
    end
    else begin
        multi2_shift <= 0;
        multi1_shift <= 0;
        multi_sum <= 0;
    end
end

// multiply result
reg [2 * DATAWIDTH - 1:0] result;
assign product = result;

always @(posedge clk) begin
    if (cnt == DATAWIDTH)
        result <= multi_sum;
    else
        result <= 1'b0;
end

endmodule
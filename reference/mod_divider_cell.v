// single step of the divisor
// parameter 26 means width of dividend left
// parameter 14 means the actual width of divisor
module mod_divider_cell 
(
    input  clk,

    input [14:0] dividend,              // 14 + 1 bits, the part of dividend used in the calculation
    input [13:0] divisor,
    input [25:0] merchant_old ,       // (26 - 14 + 1) bits, the merchant of last stage
    input [25:0] dividend_old ,     // the part of dividend need to be reserved

    output reg [25:0] dividend_kp,  // the reserved part of divident
    output reg [13:0] divisor_kp,     // the reserved part of divisor
    output reg [25:0] merchant,       // the merchant of this stage
    output reg [13:0] remainder       // 14 bits, the remainder of this stage
);

    always @(posedge clk) begin
        // keep the input signal          
        divisor_kp <= divisor;  
        dividend_kp <= dividend_old;
        // the merchant is 1:
        if (dividend >= {1'b0, divisor}) begin  
            merchant <= (merchant_old<<1) + 1'b1;
            remainder <= dividend - {1'b0, divisor}; // divident is always (14 + 1) bits
        end
        // the merchant is 0:
        else begin                           
          merchant <= merchant_old<<1;
          remainder <= dividend[13:0];
        end 
    end
endmodule

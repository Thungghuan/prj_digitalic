// main part of the divisor
// parameter 26 means the actual width of dividend
// parameter 14 means the actual width of divisor
module mod_divider
(
    input clk,

    input [25:0] dividend,
    input [13:0] divisor,

    output [25:0] merchant, // the final merchant
    output [13:0] remainder // the final remainder
); 

    // wire interconnected (temporarily save the data)
    wire [25:0] dividend_t [25:0];
    wire [13:0] divisor_t [25:0];
    wire [13:0] remainder_t [25:0];
    wire [25:0] merchant_t [25:0];

    // initialize the 1st divider cell
    mod_divider_cell u_divider_step0
    ( 
        .clk(clk),

        // use the 14SB of the dividend as the dividend of 1st step division
        .dividend({{(14){1'b0}}, dividend[25]}), // 14+1 bits
        .divisor(divisor),                       // 14 bits
        .merchant_old({26{1'b0}}),                // 26 bits            
        .dividend_old(dividend),                 // 
          
        .dividend_kp(dividend_t[25]),           // 26 bits, 26th 
        .divisor_kp(divisor_t[25]),             // 14 bits, 26th
        .merchant(merchant_t[25]),              // 26 bits, 26th
        .remainder(remainder_t[25])             // 14 bits, 26th
    );

    // generate the following divider cells
    genvar i;
    generate
    for(i = 1; i < 26; i = i + 1) begin                   // 25 loops                    
        mod_divider_cell u_divider_step
        (
            .clk(clk),

            .dividend({remainder_t[26-i], dividend_t[26-i][26-i-1]}),  
            // dividend = (reminder of last stage) + (1 more bit of original divident)       
            .divisor(divisor_t[26-i]),                             
            .merchant_old(merchant_t[26-i]),                
            .dividend_old(dividend_t[26-i]),                 
            
            // output
            .divisor_kp(divisor_t[26-i-1]),                      
            .dividend_kp(dividend_t[26-i-1]),                    
            .merchant(merchant_t[26-i-1]),                       
            .remainder(remainder_t[26-i-1])                     
        );
        end
    endgenerate

    assign merchant = merchant_t[0];    // regard the last merchant as final merchant
    assign remainder = remainder_t[0];  // regard the last remainder as final remainder

endmodule

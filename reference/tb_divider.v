module tb_divider;

parameter M = 26;
parameter N = 14;

reg clk;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

reg [11:0] a = 12'b0111_1111_1111;
reg [13:0] b = 14'b00_0000_0000_0001;

wire [M - 1:0] dividend = {a, {14{1'b0}}};
wire [N - 1:0] divisor = b;
wire [M - 1:0] quotient;

mod_divider d (.clk(clk), .dividend(dividend), .divisor(divisor), .merchant(quotient));

initial begin
    $dumpfile("./output/wave.vcd");
	$dumpvars(0, tb_divider);
    #10000 $finish;
end

endmodule

module tb_divider;

parameter M = 26;
parameter N = 14;

reg clk;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

reg [11:0] a = 12'b1001_1101_0110;
reg [13:0] b = 14'b00_1011_0100_1011;

wire [M - 1:0] dividend = {a, {14{1'b0}}};
wire [N - 1:0] divisor = b;
wire [M - 1:0] quotient;
wire divider_ok;

reg en = 1'b0;

divider d (.clk(clk), .en(en), .dividend(dividend), .divisor(divisor), .quotient(quotient), .divider_ok(divider_ok));

initial begin
    en = 1'b0;
    #8;
    en = 1'b1;
end

initial begin
    $dumpfile("./output/wave_div.vcd");
	$dumpvars(0, tb_divider);
    #10000 $finish;
end

endmodule

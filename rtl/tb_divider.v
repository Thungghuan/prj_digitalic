module tb_divider;

parameter M = 26;
parameter N = 14;

reg clk;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

reg [11:0] a = 12'b0000_0010_0000;
reg [13:0] b = 14'b00_0000_0000_1000;

wire [M - 1:0] dividend = {a, {14{1'b0}}};
wire [N - 1:0] divisor = b;
wire [M - 1:0] quotient;

divider d (.clk(clk), .dividend(dividend), .divisor(divisor), .quotient(quotient));

initial begin
    $dumpfile("./output/wave.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_divider);
    #10000 $finish;
end

endmodule

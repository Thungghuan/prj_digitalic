module tb_multiplier;

parameter M = 26;
parameter N = 14;

reg clk;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

reg [M - 1:0] multi1 = 26'b00_0000_0101_0000_1010_0000_0001;
reg [N - 1:0] multi2 = 14'b11_0000_0010_0100;
wire [M + N - 1:0] product;

reg en = 1'b0;

multiplier m (.clk(clk), .en(en), .multi1(multi1), .multi2(multi2), .product(product));

initial begin
    en = 1'b0;
    #8;
    en = 1'b1;
end

initial begin
    $dumpfile("./output/wave_mul.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_multiplier);
    #10000 $finish;
end

endmodule

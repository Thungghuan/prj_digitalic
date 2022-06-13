module tb_multiplier;

parameter DATAWIDTH = 14;
reg clk;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

reg [DATAWIDTH - 1:0] multi1 = 8'b1111_1111;
reg [DATAWIDTH - 1:0] multi2 = 8'b0000_0100;
wire [2 * DATAWIDTH - 1:0] product;

multiplier m (.clk(clk), .multi1(multi1), .multi2(multi2), .product(product));

initial begin
    $dumpfile("./output/wave.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_multiplier);
    #10000 $finish;
end


endmodule

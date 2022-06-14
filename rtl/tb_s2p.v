module tb_s2p;

parameter bit = 10;

reg clk, din;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

always begin
    din = 0 ; #3 ;
    din = 1 ; #7 ;
    din = 1 ; #3 ;
    din = 0 ; #7 ;
    din = 0 ; #3 ;
    din = 1 ; #7 ;
    din = 1 ; #3 ;
    din = 0 ; #7 ;
    din = 1 ; #3 ;
    din = 1 ; #7 ;
    din = 0 ; #3 ;
    din = 1 ; #7 ;
    din = 0 ; #3 ;
    din = 1 ; #7 ;
    din = 1 ; #3 ;
end

wire [bit - 1:0] dout;

s2p m(.clk(clk), .din(din), .dout(dout));

initial begin
    $dumpfile("./output/wave.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_s2p);
    #10000 $finish;
end

endmodule

module tb_s2p;

parameter bit = 10;

reg clk, dext;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

always begin
    dext = 0 ; #3 ;
    dext = 1 ; #7 ;
    dext = 1 ; #3 ;
    dext = 0 ; #7 ;
    dext = 0 ; #3 ;
    dext = 1 ; #7 ;
    dext = 1 ; #3 ;
    dext = 0 ; #7 ;
    dext = 1 ; #3 ;
    dext = 1 ; #7 ;
    dext = 0 ; #3 ;
    dext = 1 ; #7 ;
    dext = 0 ; #3 ;
    dext = 1 ; #7 ;
    dext = 1 ; #3 ;
end

reg en;
wire [bit - 1:0] dout;

s2p m(.clk(clk), .en(en), .dext(dext), .dout(dout));

initial begin
    en = 1'b0;
    #8;
    en = 1'b1;
end


initial begin
    $dumpfile("./output/wave_s2p.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_s2p);
    #10000 $finish;
end

endmodule

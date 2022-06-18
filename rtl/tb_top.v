module tb_top;

reg clk, e;
reg [11:0] a, b, c;

wire [13:0] y;

//clock
always begin
    clk = 0 ; #5 ;
    clk = 1 ; #5 ;
end

always begin
    e = 0 ; #3 ;
    e = 1 ; #7 ;
    e = 1 ; #3 ;
    e = 1 ; #7 ;
    e = 1 ; #3 ;
    e = 1 ; #7 ;
    e = 1 ; #3 ;
    e = 0 ; #7 ;
    e = 1 ; #3 ;
    e = 1 ; #7 ;
    e = 0 ; #3 ;
    e = 1 ; #7 ;
    e = 0 ; #3 ;
    e = 1 ; #7 ;
    e = 1 ; #3 ;
end

module_top top(
    .clk(clk),
    .a(a),
    .b(b),
    .c(c),
    .e(e),

    .y(y)
);

initial
begin
    a = 12'b1101_1111_1100;
    b = 12'b0101_1011_0100;
    c = 12'b0000_1110_0111;

    $dumpfile("./output/wave_top.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	$dumpvars(0, tb_top);
    #10000 $finish;
end

endmodule
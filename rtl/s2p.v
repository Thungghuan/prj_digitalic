module s2p(clk, dext, dout);

parameter bit = 10;

input clk, dext;
output reg [bit - 1:0] dout;

reg [bit - 1:0] q;
wire dext;

reg en;
// reg [3:0] count;
integer count = 0;

always @ (posedge clk) begin
    if (count == 4'd9) begin
        en <= 1;
        count <= 0;        
    end
    else begin
        en <= 0;
        count <= count + 1'b1;
    end
end

always @ (posedge clk)
    q <= {dext, q[bit - 1:1]};

always @ (q)
    begin
        if (en)
            dout <= q;
        else
            dout <= dout;
    end

endmodule


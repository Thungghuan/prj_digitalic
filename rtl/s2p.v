module s2p(
    clk,
    en,
    dext,

    dout,
    s2p_ok
);

parameter bit = 10;

input clk, en, dext;

output reg [bit - 1:0] dout;
output reg s2p_ok;

reg [bit - 1:0] q;
wire dext;

reg [3:0] count;

always @ (posedge clk) begin
    if (!en) begin
        q <= 0;
        count <= 0;
        s2p_ok <= 0;
        dout <= 0;
    end
    else begin
        q <= {dext, q[bit - 1:1]};
        if (count == bit - 1 && !s2p_ok) begin
            count <= 0;
            s2p_ok <= 1;
            dout <= q;
        end
        else begin
            count <= count + 1'b1;
            dout <= dout;
        end
    end
end

endmodule

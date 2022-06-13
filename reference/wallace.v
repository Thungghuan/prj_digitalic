module mod_wallace ( x,y,out);
	
	parameter x_width = 17;
	parameter y_width = 5;
	
	input [x_width-1:0] x;
	input [y_width-1:0] y;
	output [9:0] out;

	wire [x_width-1:0] y0,y1,y2,y3,y4;
	// wire [15:0] a;
	wire [1:0] b0,b1,b2,b3,b4,b5;
	wire [1:0] c0,c1,c2,c3,c4,c5,c6;
	wire [1:0] d0,d1,d2,d3,d4,d5,d6,d7;
	wire [8:0] add_a,add_b;
	wire [8:0] add_out;
	wire [9:0] out;
	
genvar i;
//generate xy
generate 
    for(i=0; i<x_width; i=i+1) begin:xy
		assign y0[i] = x[i] & y[0];
		assign y1[i] = x[i] & y[1];
		assign y2[i] = x[i] & y[2];
		assign y3[i] = x[i] & y[3];
		assign y4[i] = x[i] & y[4];
    end
endgenerate

/********************first stage********************/
	hadd h1  (.x(y4[0]),  .y(y3[1]),  .out(b0));
	fadd f1  (.x(y4[1]),  .y(y3[2]),  .z(y2[3]), .out(b1));
	fadd f2  (.x(y4[2]),  .y(y3[3]),  .z(y2[4]), .out(b2));
	fadd f3  (.x(y4[3]),  .y(y3[4]),  .z(y2[5]), .out(b3));
	fadd f4  (.x(y4[4]),  .y(y3[5]),  .z(y2[6]), .out(b4));
	fadd f5  (.x(y4[5]),  .y(y3[6]),  .z(y2[7]), .out(b5));
/* 	fadd f6  (.x(y4[6]),  .y(y3[7]),  .z(y2[8]), .out(b6));
	fadd f7  (.x(y4[7]),  .y(y3[8]),  .z(y2[9]), .out(b7));
	fadd f8  (.x(y4[8]),  .y(y3[9]),  .z(y2[10]), .out(b8));
	fadd f9  (.x(y4[9]),  .y(y3[10]),  .z(y2[11]), .out(b9));
	fadd f10 (.x(y4[10]),  .y(y3[11]),  .z(y2[12]), .out(b10));
	fadd f11 (.x(y4[11]),  .y(y3[12]),  .z(y2[13]), .out(b11));
	fadd f12 (.x(y4[12]),  .y(y3[13]),  .z(y2[14]), .out(b12));
	hadd h2  (.x(y4[13]),  .y(y3[14]),  .out(b13)); */

/********************second stage********************/
	hadd h3  (.x(y3[0]),   .y(y2[1]),  .out(c0));
	fadd f13 (.x(b0[0]),   .y(y2[2]),   .z(y1[3]),  .out(c1));
	fadd f14 (.x(b0[1]),   .y(b1[0]),   .z(y1[4]),  .out(c2));
	fadd f15 (.x(b1[1]),   .y(b2[0]),   .z(y1[5]),  .out(c3));
	fadd f16 (.x(b2[1]),   .y(b3[0]),   .z(y1[6]),  .out(c4));
	fadd f17 (.x(b3[1]),   .y(b4[0]),   .z(y1[7]),  .out(c5));
	fadd f18 (.x(b4[1]),   .y(b5[0]),   .z(y1[8]),  .out(c6));
/* 	fadd f19 (.x(b5[1]),   .y(b6[0]),   .z(y1[9]),  .out(c7));
	fadd f20 (.x(b6[1]),   .y(b7[0]),   .z(y1[10]), .out(c8));
	fadd f21 (.x(b7[1]),   .y(b8[0]),   .z(y1[11]), .out(c9));
	fadd f22 (.x(b8[1]),   .y(b9[0]),   .z(y1[12]), .out(c10));
	fadd f23 (.x(b9[1]),   .y(b10[0]),  .z(y1[13]), .out(c11));
	fadd f24 (.x(b10[1]),  .y(b11[0]),  .z(y1[14]), .out(c12));
	fadd f25 (.x(b11[1]),  .y(b12[0]),  .z(y1[15]), .out(c13));
	fadd f26 (.x(b12[1]),  .y(b13[0]),  .z(y2[15]), .out(c14));
	fadd f27 (.x(b13[1]),  .y(y4[13]),  .z(y3[15]), .out(c15)); */
	
/********************third stage********************/
	hadd h4  (.x(y2[0]),   .y(y1[1]),  .out(d0));
	fadd f28 (.x(c0[0]),   .y(y1[2]),   .z(y0[3]),  .out(d1));
	fadd f29 (.x(c0[1]),   .y(c1[0]),   .z(y0[4]),  .out(d2));
	fadd f30 (.x(c1[1]),   .y(c2[0]),   .z(y0[5]),  .out(d3));
	fadd f31 (.x(c2[1]),   .y(c3[0]),   .z(y0[6]),  .out(d4));
	fadd f32 (.x(c3[1]),   .y(c4[0]),   .z(y0[7]),  .out(d5));
	fadd f33 (.x(c4[1]),   .y(c5[0]),   .z(y0[8]),  .out(d6));
	fadd f34 (.x(c5[1]),   .y(c6[0]),   .z(y0[9]),  .out(d7));
/* 	fadd f35 (.x(c6[1]),   .y(c7[0]),   .z(y0[10]), .out(d8));
	fadd f36 (.x(c7[1]),   .y(c8[0]),   .z(y0[11]), .out(d9));
	fadd f37 (.x(c8[1]),   .y(c9[0]),   .z(y0[12]), .out(d10));
	fadd f38 (.x(c9[1]),   .y(c10[0]),  .z(y0[13]), .out(d11));
	fadd f39 (.x(c10[1]),  .y(c11[0]),  .z(y0[14]), .out(d12));
	fadd f40 (.x(c11[1]),  .y(c12[0]),  .z(y0[15]), .out(d13));
	fadd f41 (.x(c12[1]),  .y(c13[0]),  .z(y0[15]), .out(d14));
	fadd f42 (.x(c13[1]),  .y(c14[0]),  .z(y1[16]), .out(d15));
	fadd f43 (.x(c14[1]),  .y(c15[0]),  .z(y2[16]), .out(d16));
	fadd f44 (.x(c15[1]),  .y(y4[15]),  .z(y3[16]), .out(d17)); */
	
/********************final stage********************/
	assign add_a = {d6[1], d5[1], d4[1], d3[1], d2[1], d1[1], d0[1], d0[0], y1[0]};//9位
	assign add_b = {d7[0], d6[0], d5[0], d4[0], d3[0], d2[0], d1[0], y0[2], y0[1]};
	
	wire[1:0] c;
	
	fulladd4 u0(
		.a	(add_a[3:0]		),
		.b  (add_b[3:0]		),
		.ci	(1'b0			),
		.s  (add_out[3:0]	),
		.co (c[0]			)
	);
	
	fulladd4 u1(
		.a	(add_a[7:4]		),
		.b  (add_b[7:4]		),
		.ci	(c[0]			),
		.s  (add_out[7:4]	),
		.co (c[1]			)
	);
	
	assign add_out[8] = add_a[8] ^ add_b[8] ^ c[1] ; 
	// fadd f35 (.x(add_a[8]),   .y(add_b[8]),   .z(c[1]),  .out(add_out[9:8]));
	// assign add_out = add_a + add_b;
	assign out = { add_out[8:0], y0[0] };
	
endmodule


module hadd (
  input x,
  input y,
  output[1:0] out
);
  assign out = x+y; 
endmodule


module fadd (
  input x,
  input y,
  input z,
  output[1:0] out
);
  assign out = x+y+z; 
endmodule


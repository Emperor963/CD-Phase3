module pc_reg(input clk, 
              input rst, 
              input [15:0] d, 
              input wen, 
              inout [15:0] q
);

dff s0(.q(q[0]), .d(d[0]), .wen(wen), .clk(clk), .rst(rst));
dff s1(.q(q[1]), .d(d[1]), .wen(wen), .clk(clk), .rst(rst));
dff s2(.q(q[2]), .d(d[2]), .wen(wen), .clk(clk), .rst(rst));
dff s3(.q(q[3]), .d(d[3]), .wen(wen), .clk(clk), .rst(rst));
dff s4(.q(q[4]), .d(d[4]), .wen(wen), .clk(clk), .rst(rst));
dff s5(.q(q[5]), .d(d[5]), .wen(wen), .clk(clk), .rst(rst));
dff s6(.q(q[6]), .d(d[6]), .wen(wen), .clk(clk), .rst(rst));
dff s7(.q(q[7]), .d(d[7]), .wen(wen), .clk(clk), .rst(rst));
dff s8(.q(q[8]), .d(d[8]), .wen(wen), .clk(clk), .rst(rst));
dff s9(.q(q[9]), .d(d[9]), .wen(wen), .clk(clk), .rst(rst));
dff s10(.q(q[10]), .d(d[10]), .wen(wen), .clk(clk), .rst(rst));
dff s11(.q(q[11]), .d(d[11]), .wen(wen), .clk(clk), .rst(rst));
dff s12(.q(q[12]), .d(d[12]), .wen(wen), .clk(clk), .rst(rst));
dff s13(.q(q[13]), .d(d[13]), .wen(wen), .clk(clk), .rst(rst));
dff s14(.q(q[14]), .d(d[14]), .wen(wen), .clk(clk), .rst(rst));
dff s15(.q(q[15]), .d(d[15]), .wen(wen), .clk(clk), .rst(rst));


endmodule
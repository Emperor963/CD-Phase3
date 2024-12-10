module flag_reg(
    input clk, 
    input rst, 
    input [2:0] wr,
    input [2:0] in, 
    output [2:0] out
);

dff u1(.q(out[0]), .d(in[0]), .wen(wr[0]), .clk(clk), .rst(rst));
dff u2(.q(out[1]), .d(in[1]), .wen(wr[1]), .clk(clk), .rst(rst));
dff u3(.q(out[2]), .d(in[2]), .wen(wr[2]), .clk(clk), .rst(rst));

endmodule
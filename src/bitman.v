module bitman (
input LH, //0 = llb, 1 = lhb
input [15:0] RD1,
input [7:0] i,

output [15:0] RD

);

wire [15:0] lb;
wire [15:0] hb;

assign lb[15:8] = RD1[15:8];
assign hb[7:0] = RD1[7:0];

assign lb[7:0] = i;
assign hb[15:8] = i;

assign RD = (LH) ? hb:lb;

endmodule
module Bitcell(
    input clk,
    input rst,
    input d, 
    input wen, //write enable
    input ren1, //read enable
    input ren2, //read enable
    

    inout bitline1,
    inout bitline2
);

wire out;

dff flip_flop(.q(out), 
              .d(d), 
              .wen(wen), 
              .clk(clk), 
              .rst(rst)
);

assign bitline1 = ren1 ? out : 1'bz;
assign bitline2 = ren2 ? out : 1'bz;

endmodule
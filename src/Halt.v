module Halt(
    input clk,
    input rst,
    input wen,
    input in,

    output out
);


dff halt(.clk(clk), .rst(rst), .wen(wen), .d(in), .q(out));

endmodule
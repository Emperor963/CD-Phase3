module Register4(
    input clk,
    input rst,
    input [3:0] d,         
    input wen,             
    
    inout [3:0] out  
);

Bitcell bit0(.clk(clk), .rst(rst), .d(d[0]), .wen(wen), .ren1(1'b1), .ren2(), 
             .bitline1(out[0]), .bitline2());
Bitcell bit1(.clk(clk), .rst(rst), .d(d[1]), .wen(wen), .ren1(1'b1), .ren2(), 
             .bitline1(out[1]), .bitline2());
Bitcell bit2(.clk(clk), .rst(rst), .d(d[2]), .wen(wen), .ren1(1'b1), .ren2(), 
             .bitline1(out[2]), .bitline2());
Bitcell bit3(.clk(clk), .rst(rst), .d(d[3]), .wen(wen), .ren1(1'b1), .ren2(), 
             .bitline1(out[3]), .bitline2());

endmodule

module Register(
    input clk,
    input rst,
    input[15:0] d,
    input write_reg,
    input ren1,
    input ren2,
    
    inout[15:0] bitline1,
    inout[15:0] bitline2
);

Bitcell bit0(.clk(clk), .rst(rst), .d(d[0]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[0]), .bitline2(bitline2[0]));
Bitcell bit1(.clk(clk), .rst(rst), .d(d[1]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[1]), .bitline2(bitline2[1]));
Bitcell bit2(.clk(clk), .rst(rst), .d(d[2]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[2]), .bitline2(bitline2[2]));
Bitcell bit3(.clk(clk), .rst(rst), .d(d[3]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[3]), .bitline2(bitline2[3]));
Bitcell bit4(.clk(clk), .rst(rst), .d(d[4]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[4]), .bitline2(bitline2[4]));
Bitcell bit5(.clk(clk), .rst(rst), .d(d[5]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[5]), .bitline2(bitline2[5]));
Bitcell bit6(.clk(clk), .rst(rst), .d(d[6]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[6]), .bitline2(bitline2[6]));
Bitcell bit7(.clk(clk), .rst(rst), .d(d[7]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[7]), .bitline2(bitline2[7]));
Bitcell bit8(.clk(clk), .rst(rst), .d(d[8]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[8]), .bitline2(bitline2[8]));
Bitcell bit9(.clk(clk), .rst(rst), .d(d[9]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[9]), .bitline2(bitline2[9]));
Bitcell bit10(.clk(clk), .rst(rst), .d(d[10]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[10]), .bitline2(bitline2[10]));
Bitcell bit11(.clk(clk), .rst(rst), .d(d[11]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[11]), .bitline2(bitline2[11]));
Bitcell bit12(.clk(clk), .rst(rst), .d(d[12]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[12]), .bitline2(bitline2[12]));
Bitcell bit13(.clk(clk), .rst(rst), .d(d[13]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[13]), .bitline2(bitline2[13]));
Bitcell bit14(.clk(clk), .rst(rst), .d(d[14]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[14]), .bitline2(bitline2[14]));
Bitcell bit15(.clk(clk), .rst(rst), .d(d[15]), .wen(write_reg), .ren1(ren1), .ren2(ren2), 
             .bitline1(bitline1[15]), .bitline2(bitline2[15]));







endmodule
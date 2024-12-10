module Register_File(
    input clk,
    input rst,
    input [3:0] src_reg1,
    input [3:0] src_reg2,
    input [3:0] dst_reg,
    input write_reg,

    input [15:0] dst_data,
    inout [15:0] src_data1,
    inout [15:0] src_data2
);

wire [15:0] src_ren1; //Array of read enable signals for 16 registers
wire [15:0] src_ren2; //Array of read enable signals for 16 registers
wire [15:0] wen;      //Array of write enable signals for 16 registers
read_decoder_4_16 rdcd1(.reg_id(src_reg1), .wordline(src_ren1));
read_decoder_4_16 rdcd2(.reg_id(src_reg2), .wordline(src_ren2));
write_decoder_4_16 wdcd(.reg_id(dst_reg), .write_reg(write_reg), .wordline(wen));

wire [15:0] src1;
wire [15:0] src2; //Note these wires are temporary storage for src_data1 and src_data2 because I 
                  // do not want any problems with the inout type of these register data


Register r0(.clk(clk), .rst(rst), .d(16'b0000_0000_0000_0000), .write_reg(1'b0), 
              .ren1(src_ren1[0]), .ren2(src_ren2[0]), .bitline1(src1), .bitline2(src2));
Register r1(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[1]), 
            .ren1(src_ren1[1]), .ren2(src_ren2[1]), .bitline1(src1), .bitline2(src2));
Register r2(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[2]),
            .ren1(src_ren1[2]), .ren2(src_ren2[2]), .bitline1(src1), .bitline2(src2));
Register r3(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[3]), 
            .ren1(src_ren1[3]), .ren2(src_ren2[3]), .bitline1(src1), .bitline2(src2));
Register r4(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[4]), 
            .ren1(src_ren1[4]), .ren2(src_ren2[4]), .bitline1(src1), .bitline2(src2));
Register r5(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[5]), 
            .ren1(src_ren1[5]), .ren2(src_ren2[5]), .bitline1(src1), .bitline2(src2));
Register r6(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[6]), 
            .ren1(src_ren1[6]), .ren2(src_ren2[6]), .bitline1(src1), .bitline2(src2));
Register r7(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[7]), 
            .ren1(src_ren1[7]), .ren2(src_ren2[7]), .bitline1(src1), .bitline2(src2));
Register r8(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[8]), 
            .ren1(src_ren1[8]), .ren2(src_ren2[8]), .bitline1(src1), .bitline2(src2));
Register r9(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[9]), 
            .ren1(src_ren1[9]), .ren2(src_ren2[9]), .bitline1(src1), .bitline2(src2));
Register r10(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[10]), 
             .ren1(src_ren1[10]), .ren2(src_ren2[10]), .bitline1(src1), .bitline2(src2));
Register r11(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[11]), 
            .ren1(src_ren1[11]), .ren2(src_ren2[11]), .bitline1(src1), .bitline2(src2));
Register r12(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[12]), 
            .ren1(src_ren1[12]), .ren2(src_ren2[12]), .bitline1(src1), .bitline2(src2));
Register r13(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[13]), 
            .ren1(src_ren1[13]), .ren2(src_ren2[13]), .bitline1(src1), .bitline2(src2));
Register r14(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[14]), 
            .ren1(src_ren1[14]), .ren2(src_ren2[14]), .bitline1(src1), .bitline2(src2));
Register r15(.clk(clk), .rst(rst), .d(dst_data), .write_reg(wen[15]), 
            .ren1(src_ren1[15]), .ren2(src_ren2[15]), .bitline1(src1), .bitline2(src2));


assign src_data1 = src1;
assign src_data2 = src2;

endmodule
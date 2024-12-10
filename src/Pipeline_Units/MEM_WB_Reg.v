module MEM_WB_Reg(
    input clk,
    input rst, 
    input wren,

    input [1:0] iMemtoReg,
    input iRegWrite,
    input iHLT,

    input [15:0] iLBOut,
    input [15:0] iMemRd, //Memory Read output
    input [15:0] iALUOut,
    input [3:0] idst_reg,
    input [15:0] pc_in,


    output [1:0] MemtoReg,
    output RegWrite,
    output HLT,

    output [15:0] LBOut,
    output [15:0] MemRd,
    output [15:0] ALUOut,
    output [3:0] dst_reg,
    output [15:0] pc_out
);

dff memtoreg0(.q(MemtoReg[0]), .d(iMemtoReg[0]), .wen(wren),  .clk(clk), .rst(rst));
dff memtoreg1(.q(MemtoReg[1]), .d(iMemtoReg[1]), .wen(wren),  .clk(clk), .rst(rst));
dff regwrite(.q(RegWrite), .d(iRegWrite), .wen(wren), .clk(clk), .rst(rst));
dff hlt(.q(HLT), .d(iHLT), .wen(wren), .clk(clk), .rst(rst));

dff dst0(.q(dst_reg[0]), .d(idst_reg[0]), .wen(wren), .clk(clk), .rst(rst));
dff dst1(.q(dst_reg[1]), .d(idst_reg[1]), .wen(wren), .clk(clk), .rst(rst));
dff dst2(.q(dst_reg[2]), .d(idst_reg[2]), .wen(wren), .clk(clk), .rst(rst));
dff dst3(.q(dst_reg[3]), .d(idst_reg[3]), .wen(wren), .clk(clk), .rst(rst));

Register BitManOut(.clk(clk), .rst(rst), .d(iLBOut), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(LBOut), .bitline2());
Register aluout(.clk(clk), .rst(rst), .d(iALUOut), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(ALUOut), .bitline2());
Register MemRead(.clk(clk), .rst(rst), .d(iMemRd), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(MemRd), .bitline2());
Register pcHold(.clk(clk), .rst(rst), .d(pc_in), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(pc_out), .bitline2());




endmodule
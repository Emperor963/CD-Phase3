module EX_MEM_Reg(
    input clk,
    input rst,
    input wren,

    input iMemRead,
    input [1:0] iMemtoReg,
    input iMemWrite,
    input iRegWrite, 
    input [2:0] ifwr,
    input iHLT,

    input [15:0] iLBout,
    input [2:0] iFR, //flag reg
    input [15:0] iALUout,
    input [15:0] iReadValue,
    input [3:0] idst_reg,
    input [15:0] pc_in,

    output MemRead,
    output [1:0] MemtoReg,
    output MemWrite,
    output RegWrite,
    output [2:0] fwr,
    output HLT,

    output [15:0] LBOut,
    output [2:0] FR,
    output [15:0] ALUOut,
    output [15:0] ReadValue,
    output [3:0] dst_reg,
    output [15:0] pc_out
);


dff memread(.q(MemRead), .d(iMemRead), .wen(wren), .clk(clk), .rst(rst));
dff memtoreg0(.q(MemtoReg[0]), .d(iMemtoReg[0]), .wen(wren),  .clk(clk), .rst(rst));
dff memtoreg1(.q(MemtoReg[1]), .d(iMemtoReg[1]), .wen(wren),  .clk(clk), .rst(rst));
dff memwrite(.q(MemWrite), .d(iMemWrite), .wen(wren), .clk(clk), .rst(rst));
dff regwrite(.q(RegWrite), .d(iRegWrite), .wen(wren), .clk(clk), .rst(rst));
dff hlt(.q(HLT), .d(iHLT), .wen(wren), .clk(clk), .rst(rst));
dff fwr0(.q(fwr[0]), .d(ifwr[0]), .wen(wren), .clk(clk), .rst(rst));
dff fwr1(.q(fwr[1]), .d(ifwr[1]), .wen(wren), .clk(clk), .rst(rst));
dff fwr2(.q(fwr[2]), .d(ifwr[2]), .wen(wren), .clk(clk), .rst(rst));


dff flag0(.q(FR[0]), .d(iFR[0]), .wen(wren), .clk(clk), .rst(rst));
dff flag1(.q(FR[1]), .d(iFR[1]), .wen(wren), .clk(clk), .rst(rst));
dff flag2(.q(FR[2]), .d(iFR[2]), .wen(wren), .clk(clk), .rst(rst));

dff dst0(.q(dst_reg[0]), .d(idst_reg[0]), .wen(wren), .clk(clk), .rst(rst));
dff dst1(.q(dst_reg[1]), .d(idst_reg[1]), .wen(wren), .clk(clk), .rst(rst));
dff dst2(.q(dst_reg[2]), .d(idst_reg[2]), .wen(wren), .clk(clk), .rst(rst));
dff dst3(.q(dst_reg[3]), .d(idst_reg[3]), .wen(wren), .clk(clk), .rst(rst));



Register BitManOut(.clk(clk), .rst(rst), .d(iLBout), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(LBOut), .bitline2());
Register aluout(.clk(clk), .rst(rst), .d(iALUout), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(ALUOut), .bitline2());
Register ReadVal(.clk(clk), .rst(rst), .d(iReadValue), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(ReadValue), .bitline2());
Register pcHold(.clk(clk), .rst(rst), .d(pc_in), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(pc_out), .bitline2());

endmodule
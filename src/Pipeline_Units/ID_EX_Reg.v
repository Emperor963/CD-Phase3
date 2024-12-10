module ID_EX_Reg(
    input clk,
    input rst,
    input wren,    

    //input iRegRead, //might not need this
    input iMemRead,
    input [1:0] iMemtoReg,
    input iMemWrite,
    input [2:0] iALUOp,
    input iALUsrc,
    input iRegWrite,
    //input [1:0] iPCSour, //might not need this either
    input iLH,
    input iHLT,
    input [2:0] ifwr,

    input [15:0] pc_in,
    input [2:0] iFLAG,
    input [15:0] isrc_rd1,
    input [15:0] isrc_rd2,

    input [15:0] iALUImm,
    input [15:0] iLBImm,
    input [3:0] iRt,
    input [3:0] iRs,
    input [3:0] idst_reg,


    //output RegRead, 
    output MemRead,
    output [1:0] MemtoReg,
    output MemWrite,
    output [2:0] ALUOp,
    output ALUSrc,
    output RegWrite,
    //output [1:0] PCSour,
    output LH,
    output HLT,
    output [2:0] fwr,

    output [15:0] pc_out,
    output [2:0] FLAG,
    output [15:0] src_rd1,
    output [15:0] src_rd2,
    
    output [15:0] ALUImm,
    output [15:0] LBImm,
    output [3:0] Rt,
    output [3:0] Rs,
    output [3:0] dst_reg
);


//dff regread(.q(RegRead), .d(iRegRead), .wen(wren), .clk(clk), .rst(rst));
dff memread(.q(MemRead), .d(iMemRead), .wen(wren), .clk(clk), .rst(rst));
dff memtoreg0(.q(MemtoReg[0]), .d(iMemtoReg[0]), .wen(wren),  .clk(clk), .rst(rst));
dff memtoreg1(.q(MemtoReg[1]), .d(iMemtoReg[1]), .wen(wren),  .clk(clk), .rst(rst));
dff memwrite(.q(MemWrite), .d(iMemWrite), .wen(wren), .clk(clk), .rst(rst));
dff aluop0(.q(ALUOp[0]), .d(iALUOp[0]), .wen(wren), .clk(clk), .rst(rst));
dff aluop1(.q(ALUOp[1]), .d(iALUOp[1]), .wen(wren), .clk(clk), .rst(rst));
dff aluop2(.q(ALUOp[2]), .d(iALUOp[2]), .wen(wren), .clk(clk), .rst(rst));
dff alusrc(.q(ALUSrc), .d(iALUsrc), .wen(wren), .clk(clk), .rst(rst));
dff regwrite(.q(RegWrite), .d(iRegWrite), .wen(wren), .clk(clk), .rst(rst));
/*dff pcsour0(.q(PCSour[0]), .d(iPCSour[0]), .wen(wren), .clk(clk), .rst(rst));
dff pcsour1(.q(PCSour[1]), .d(iPCSour[1]), .wen(wren), .clk(clk), .rst(rst));*/
dff lh(.q(LH), .d(iLH), .wen(wren), .clk(clk), .rst(rst));
dff hlt(.q(HLT), .d(iHLT), .wen(wren), .clk(clk), .rst(rst));
dff fwr0(.q(fwr[0]), .d(ifwr[0]), .wen(wren), .clk(clk), .rst(rst));
dff fwr1(.q(fwr[1]), .d(ifwr[1]), .wen(wren), .clk(clk), .rst(rst));
dff fwr2(.q(fwr[2]), .d(ifwr[2]), .wen(wren), .clk(clk), .rst(rst));


Register pcHold(.clk(clk), .rst(rst), .d(pc_in), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(pc_out), .bitline2());
Register SRC1(.clk(clk), .rst(rst), .d(isrc_rd1), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(src_rd1), .bitline2());
Register SRC2(.clk(clk), .rst(rst), .d(isrc_rd2), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(src_rd2), .bitline2());
Register ALUImmediateValue(.clk(clk), .rst(rst), .d(iALUImm), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(ALUImm), .bitline2());
Register LBImmediateValue(.clk(clk), .rst(rst), .d(iLBImm), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(LBImm), .bitline2());


dff flag0(.q(FLAG[0]), .d(iFLAG[0]), .wen(wren), .clk(clk), .rst(rst));
dff flag1(.q(FLAG[1]), .d(iFLAG[1]), .wen(wren), .clk(clk), .rst(rst));
dff flag2(.q(FLAG[2]), .d(iFLAG[2]), .wen(wren), .clk(clk), .rst(rst));

dff RsV0(.q(Rs[0]), .d(iRs[0]), .wen(wren), .clk(clk), .rst(rst));
dff RsV1(.q(Rs[1]), .d(iRs[1]), .wen(wren), .clk(clk), .rst(rst));
dff RsV2(.q(Rs[2]), .d(iRs[2]), .wen(wren), .clk(clk), .rst(rst));
dff RsV3(.q(Rs[3]), .d(iRs[3]), .wen(wren), .clk(clk), .rst(rst));

dff RtV0(.q(Rt[0]), .d(iRt[0]), .wen(wren), .clk(clk), .rst(rst));
dff RtV1(.q(Rt[1]), .d(iRt[1]), .wen(wren), .clk(clk), .rst(rst));
dff RtV2(.q(Rt[2]), .d(iRt[2]), .wen(wren), .clk(clk), .rst(rst));
dff RtV3(.q(Rt[3]), .d(iRt[3]), .wen(wren), .clk(clk), .rst(rst));


dff dst0(.q(dst_reg[0]), .d(idst_reg[0]), .wen(wren), .clk(clk), .rst(rst));
dff dst1(.q(dst_reg[1]), .d(idst_reg[1]), .wen(wren), .clk(clk), .rst(rst));
dff dst2(.q(dst_reg[2]), .d(idst_reg[2]), .wen(wren), .clk(clk), .rst(rst));
dff dst3(.q(dst_reg[3]), .d(idst_reg[3]), .wen(wren), .clk(clk), .rst(rst));




endmodule
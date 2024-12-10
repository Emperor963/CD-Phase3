module cpu(
    input clk,
    input rst,

    output hlt,
    output [15:0] pc
);


////////////////////////////////// INITIALIZING ALL WIRES ////////////////////////////////////////////////////////

wire halter, halt;

Halt haltHold(.clk(clk), .rst(rst), .wen(halt), .in(halt), .out(halter));

wire [15:0] pc_curr, pc_next, IF_ID_pc_out, ID_EX_pc_out;
wire [15:0] instruction, IF_ID_instr_out;
wire IF_ID_STALL, pc_stall_hd1, pc_stall_hd2, pc_stall, HazDet1_IF_ID_STALL_OUT, HazDet2_IF_ID_STALL_OUT, HD_Stall, pc_wren;

wire RegRead, MemRead, MemWrite, ALUSrc, RegWrite, LH, HLT;
wire [1:0] MemtoReg, PCSrc;
wire [2:0] ALUOp, fwr;
wire [15:0] D_ALU_SEXT_Imm, D_LB_SEXT_Imm;
wire [7:0] D_LB_Imm;
wire [15:0] D_src_rd1, D_src_rd2, X_src_rd1, X_src_rd2, X_ALU_Imm, X_LB_Imm;
wire [3:0] D_Rs, D_Rt, D_Rd, D_src1, D_src2, D_ALU_Imm, D_dst_reg, X_Rt, X_Rs, X_dst_reg, M_dst_reg, W_dst_reg;
wire [2:0] flag_in, flag_out, ID_EX_flag, ALU_flag;
wire [15:0] pc_encrypted, pc_updated, branch_address;
wire ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegWrite, ID_EX_LH, ID_EX_HLT;
wire EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_RegWrite, EX_MEM_HLT;
wire MEM_WB_RegWrite, MEM_WB_HLT;
wire [1:0] ID_EX_MemtoReg;
wire [2:0] ID_EX_ALUOp, ID_EX_fwr;
wire [1:0] EX_MEM_MemtoReg;
wire [2:0] EX_MEM_fwr;
wire [1:0] MEM_WB_MemtoReg;


wire [1:0] LHControl, ALUControlA; //Forwarding unit output
wire [1:0] ALUControlB;

wire [15:0] LBOut, ALUOut;


wire [15:0] M_LBOut, M_ALUOut, M_ReadValue, EX_MEM_pc_out, DMem_Read;

wire [15:0] W_LBOut, W_DMem_Read, W_ALUOut, MEM_WB_pc_out;

//wire halt = MEM_WB_HLT;
assign pc = pc_curr;
assign hlt = halt;



///////////////////////////////// END INITIALIZATIONS ///////////////////////////////////////////////////////////








///////////////////////////////// FETCH STAGE ///////////////////////////////////////////////////////////////////

MUX16bit_4to1 PCSrcMux(.sigA(pc_updated), .sigB(RegisterBr), .sigC(pc_curr), .sigD(branch_address), .control(PCSrc), .out(pc_next));

pc_reg PCRegister(.clk(clk), .rst(rst), .d(pc_next), .wen(pc_wren), .q(pc_curr));

memory1c_instr IMem(.data_out(instruction), .addr(pc_curr), .clk(clk), .rst(rst), .enable(1'b1), .wr(1'b0));

IF_ID_Reg IF_ID(.clk(clk), .rst(rst), .wren(~pc_stall), .IFID_Flush(IFIDFlush), .pc(pc_next), .instr(instruction), .pc_out(IF_ID_pc_out), .instr_out(IF_ID_instr_out));

assign pc_wren = ~(halter | pc_stall);

//////////////////////////////// END FETCH STAGE ////////////////////////////////////////////////////////////////




//Please note that all future pc_out signals are going to be one pc ahead because the addition + 2 to pc is done in
//Decode Stage because I am too naive to get rid of my original pc_control module. The Register output does NOT reflect
//the actual pc in the pipeline stage and is actually one ahead.

/////////////////////////////// DECODE STAGE ////////////////////////////////////////////////////////////////////

assign D_Rs = IF_ID_instr_out[7:4];
assign D_Rd = IF_ID_instr_out[11:8];
assign D_Rt = IF_ID_instr_out[3:0];
assign D_ALU_Imm = D_Rt;
assign D_LB_Imm = IF_ID_instr_out[7:0];
assign D_dst_reg = IF_ID_instr_out[11:8];

SignExtend4bit SEXT4(.A(D_ALU_Imm), .B(D_ALU_SEXT_Imm));
SignExtend8bit SEXT8(.A(D_LB_Imm), .B(D_LB_SEXT_Imm));

wire RFBypassControl;

hazard_detection HazDet1(.MemtoReg(ID_EX_MemtoReg), .src1(D_src1), .src2(D_src2), .destReg(X_dst_reg), .insn(IF_ID_instr_out), 
                        .ALUSrc(ALUSrc), .RegRead(RegRead), .M_dst_reg(M_dst_reg), .pc_stall(pc_stall_hd1), .IF_DE_stall(HazDet1_IF_ID_STALL_OUT), 
                        .RFBypassControl(RFBypassControl));
control_hazard_detection HazDet2(.insn(IF_ID_instr_out), .regWriteX(ID_EX_RegWrite), .regWriteM(EX_MEM_RegWrite), 
                                 .regWriteW(MEM_WB_RegWrite), .branch_taken(branch_taken), .pc_source(PCSrc), .destRegX(X_dst_reg), 
                                 .destRegM(M_dst_reg), .destRegW(W_dst_reg), .pc_stall(pc_stall_hd2), 
                                 .IF_DE_stall(HazDet2_IF_ID_STALL_OUT));


assign pc_stall = pc_stall_hd1 | pc_stall_hd2;
assign HD_Stall = HazDet1_IF_ID_STALL_OUT | HazDet2_IF_ID_STALL_OUT;

cpu_control ControlUnit(.control(IF_ID_instr_out[15:12]), .RegRead(RegRead), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), 
                        .ALUOp(ALUOp), .ALUsrc(ALUSrc), .RegWrite(RegWrite), .PCSour(PCSrc), .LH(LH), .HLT(HLT), .fwr(fwr));




MUX4bit_2to1 RFSrcMux(.sigA(D_Rd), .sigB(D_Rs), .control(RegRead), .out(D_src1));
assign D_src2 = D_Rt;


wire [15:0] RegWriteData_F;
wire [3:0] dst_reg_F;
wire RegWrite_F;
Custom6to3MUX BypassMux(.WDataPort1(RegisterWriteData), .WDataPort2(EX_ForwardingPath), 
                        .WPortName1(W_dst_reg), .WPortName2(M_dst_reg), .InSignal1(MEM_WB_RegWrite), 
                        .InSignal2(EX_MEM_RegWrite), .ControlSignal(RFBypassControl), 
                        .DataOut(RegWriteData_F), .PortOut(dst_reg_F), .SignalOut(RegWrite_F)); 
Register_File RF(.clk(clk), .rst(rst), .src_reg1(D_src1), .src_reg2(D_src2), .dst_reg(dst_reg_F), .write_reg(RegWrite_F), 
                 .dst_data(RegWriteData_F),  .src_data1(D_src_rd1), .src_data2(D_src_rd2));

wire branchTaken;
pc_control PCController(.pc_in(IF_ID_pc_out), .imm(IF_ID_instr_out[8:0]), .FLAG(flag_out), .C(IF_ID_instr_out[11:9]), 
                        .rd1(D_src_rd1), .pc_out(pc_encrypted), .pc_update(pc_updated), .branch_taken(branch_taken));
wire [15:0] RegisterBr = (PCSrc == 01) ? D_src_rd1 : 16'h0000;
assign branch_address = pc_encrypted ^ RegisterBr;

flag_reg FlagReg(.clk(clk), .rst(rst), .wr(ID_EX_fwr), .in(ALU_flag), .out(flag_out));



assign IFIDFlush = HD_Stall;


wire MemRead_final, MemWrite_final, ALUSrc_final, RegWrite_final, LH_final, HLT_final;   //Not assigned in assign block because these are temporary (I'm just lazy)
wire [1:0] MemtoReg_final;
wire [2:0] ALUOp_final, fwr_final;


///////// STALLING MUX ///////////////////////////////  --------> Couldn't be bothered to make a separate MUX module for this even though this looks ugly as shit
assign MemRead_final = HD_Stall ? 1'b0 : MemRead; 
assign MemWrite_final = HD_Stall ? 1'b0 : MemWrite;
assign ALUSrc_final = HD_Stall ? 1'b0 : ALUSrc;
assign RegWrite_final = HD_Stall ? 1'b0 : RegWrite;
assign LH_final = HD_Stall ? 1'b0 : LH;
assign HLT_final = HD_Stall ? 1'b0 : HLT;
assign MemtoReg_final = HD_Stall ? 2'b00 : MemtoReg;
assign ALUOp_final = HD_Stall ? 3'b000 : ALUOp;
assign fwr_final = HD_Stall ? 3'b000 : fwr;
/////////////////////////////////////////////////////

ID_EX_Reg ID_EX(.clk(clk), .rst(rst), .wren(1'b1), .iMemRead(MemRead_final), .iMemtoReg(MemtoReg_final), .iMemWrite(MemWrite_final), .iALUOp(ALUOp_final), .iALUsrc(ALUSrc_final), .iRegWrite(RegWrite_final), 
                .iLH(LH_final), .iHLT(HLT_final), .ifwr(fwr_final), .pc_in(IF_ID_pc_out), .iFLAG(flag_out), .isrc_rd1(D_src_rd1), .isrc_rd2(D_src_rd2), .iALUImm(D_ALU_SEXT_Imm), .iLBImm(D_LB_SEXT_Imm), .iRt(D_Rt), .iRs(D_src1),
                .idst_reg(D_dst_reg), .MemRead(ID_EX_MemRead), .MemtoReg(ID_EX_MemtoReg), .MemWrite(ID_EX_MemWrite), .ALUOp(ID_EX_ALUOp), .ALUSrc(ID_EX_ALUSrc), .RegWrite(ID_EX_RegWrite), .LH(ID_EX_LH), .HLT(ID_EX_HLT),
                .fwr(ID_EX_fwr), .pc_out(ID_EX_pc_out), .FLAG(ID_EX_flag), .src_rd1(X_src_rd1), .src_rd2(X_src_rd2), .ALUImm(X_ALU_Imm), .LBImm(X_LB_Imm), .Rt(X_Rt), .Rs(X_Rs), .dst_reg(X_dst_reg));

////////////////////////////// END DECODE STAGE /////////////////////////////////////////////////////////////////








///////////////////////////// EXECUTE STAGE /////////////////////////////////////////////////////////////////////


wire [15:0] LB_Input;

MUX16bit_4to1 BitLoaderMux(.sigA(X_src_rd1), .sigB(MEM_ForwardingPath), .sigC(EX_ForwardingPath), .sigD(), .control(LHControl), .out(LB_Input));

bitman BitLoader(.LH(ID_EX_LH), .RD1(LB_Input), .i(X_LB_Imm[7:0]), .RD(LBOut));

wire [15:0] ALUA, ALUB;

MUX16bit_4to1 ALUSrcAMUX(.sigA(X_src_rd1), .sigB(MEM_ForwardingPath), .sigC(EX_ForwardingPath), .sigD(), .control(ALUControlA), .out(ALUA));
MUX16bit_4to1 ALUSrcBMUX(.sigA(X_src_rd2), .sigB(X_ALU_Imm), .sigC(MEM_ForwardingPath), .sigD(EX_ForwardingPath), .control(ALUControlB), .out(ALUB));

ALU ALU(.In1(ALUA), .In2(ALUB), .ALUOp(ID_EX_ALUOp), .FLAG_in(ID_EX_flag), .FLAG(ALU_flag), .ALUOut(ALUOut));

forwarding ForwardingUnit(.ALUSrc(ID_EX_ALUSrc), .EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), .ID_EX_Rt(X_Rt), 
                          .ID_EX_Rs(X_Rs), .EX_MEM_dst_reg(M_dst_reg), .MEM_WB_dst_reg(W_dst_reg), 
                          .LHControl(LHControl), .ALUControlA(ALUControlA), .ALUControlB(ALUControlB));


EX_MEM_Reg EX_MEM(.clk(clk), .rst(rst), .wren(1'b1), .iMemRead(ID_EX_MemRead), .iMemtoReg(ID_EX_MemtoReg), .iMemWrite(ID_EX_MemWrite), .iRegWrite(ID_EX_RegWrite), 
                  .ifwr(ID_EX_fwr), .iHLT(ID_EX_HLT), .iLBout(LBOut), .iFR(ALU_flag), .iALUout(ALUOut), .iReadValue(ALUB), .idst_reg(X_dst_reg), .pc_in(ID_EX_pc_out),
                  .MemRead(EX_MEM_MemRead), .MemtoReg(EX_MEM_MemtoReg), .MemWrite(EX_MEM_MemWrite), .RegWrite(EX_MEM_RegWrite), .fwr(EX_MEM_fwr), .HLT(EX_MEM_HLT),
                  .LBOut(M_LBOut), .FR(flag_in), .ALUOut(M_ALUOut), .ReadValue(M_ReadValue), .dst_reg(M_dst_reg), .pc_out(EX_MEM_pc_out));

//////////////////////////// END EXECUTE STAGE //////////////////////////////////////////////////////////////////



//FIX MUXING ISSUE AAAAAAAAAAAAAAAAAAA I'LL KMS




////////////////////////// MEMORY STAGE ////////////////////////////////////////////////////////////////////////

wire [15:0] EX_ForwardingPath = (flag_in === 3'b000) ? M_LBOut : M_ALUOut;

memory1c_data DMem(.data_out(DMem_Read), .data_in(M_ReadValue), .addr(M_ALUOut), .enable(EX_MEM_MemRead), .wr(EX_MEM_MemWrite), .clk(clk), .rst(rst));

MEM_WB_Reg MEM_WB(.clk(clk), .rst(rst), .wren(1'b1), .iMemtoReg(EX_MEM_MemtoReg), .iRegWrite(EX_MEM_RegWrite), .iHLT(EX_MEM_HLT), .iLBOut(M_LBOut), .iMemRd(DMem_Read), .iALUOut(M_ALUOut),
                  .idst_reg(M_dst_reg), .pc_in(EX_MEM_pc_out), .MemtoReg(MEM_WB_MemtoReg), .RegWrite(MEM_WB_RegWrite), .HLT(halt), .LBOut(W_LBOut), .MemRd(W_DMem_Read), .ALUOut(W_ALUOut),
                  .dst_reg(W_dst_reg), .pc_out(MEM_WB_pc_out));

////////////////////////// END MEMORY STAGE ////////////////////////////////////////////////////////////////////








///////////////////////// WRITE-BACK STAGE /////////////////////////////////////////////////////////////////////

wire [15:0] MEM_ForwardingPath;
wire [15:0] RegisterWriteData;

wire RegisterWriteDataControl = MEM_WB_MemtoReg[0] | MEM_WB_MemtoReg[1]; //THIS IS ZERO IFF MemtoReg is 00 which means PCS instruction

MUX16bit_4to1 RegisterMUX1(.sigA(16'h0000), .sigB(W_LBOut), .sigC(W_ALUOut), .sigD(W_DMem_Read), .control(MEM_WB_MemtoReg), .out(MEM_ForwardingPath));
MUX16bit_2to1 RegisterMUX2(.sigA(MEM_WB_pc_out), .sigB(MEM_ForwardingPath), .control(RegisterWriteDataControl), .out(RegisterWriteData));


///////////////////////// END WRITE-BACK STAGE /////////////////////////////////////////////////////////////////

endmodule
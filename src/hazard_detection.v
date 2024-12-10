module hazard_detection(

    input [1:0] MemtoReg, //Meme to Reg control signal from X/D stage
    input [3:0] src1,
    input [3:0] src2,
    input [3:0] destReg, //4 bit destination register from X/D stage
    input [15:0] insn, // instruction from IF/Decode
    input ALUSrc, // control signal for decode to determinif I type insn
    input RegRead, // control signal for IF/D to determine if R type insn
    input [3:0] M_dst_reg,
    
    output pc_stall, //1 means stall the pc
    output IF_DE_stall, //1 if to stall set to IF/ID resgister to output nop     
    output RFBypassControl
);

wire [3:0] regUseD; // specified in insn bits [11:8]
wire [3:0] regUseT; //specifiec in insn bits [7:4]
wire [3:0] regUseS; //specified in insn bits [3:0]
wire [3:0] opCode; // [15:12] or insns


assign regUseS = insn[7:4];
assign regUseT = insn[3:0];
assign regUseD = insn[11:8];
assign opCode = insn[15:12];

wire keyA; // is 0 if instruction in M/W is LW
wire keyB; // is 1 if instruction in I/D is arithmetic R type
wire keyC; // is 1 if insturction in I/D is arithmetic I type
wire keyD; // is 1 if instruction in I/D is LLB/LHB 
wire keyF; // check if instruction in I/D is SW

wire [3:0] regCompA; 
wire [3:0] regCompB;

// assigns comparison registers based on Insn type

assign regCompA = (keyA) ? 4'b0000: 
                  (keyD) ? regUseD: //assigns to regD if LLB or LHB
                  (keyB) ? regUseS: 4'b0000; //assigns to RegT if R type and zero reg otherwise
                  
assign regCompB = (keyA) ? 4'b0000:
                  (keyF) ? regUseD:
                  (keyC) ? regUseT:4'b0000;

//check is MW has LW insn                 
assign keyA = !(MemtoReg == 4'b11); //key A = 0 if Mw insn is LW;

//check if ID insn is R type
assign keyB = (RegRead); //rtype if not I type and reads Registers

// check if ID insn is I type
assign keyC = !(ALUSrc);

//check if ID has LLB/LHB
assign keyD =  (insn[15:13] == 3'b101); //keyD = 1 if LLB/LHB

assign keyF = (insn[15:12] == 4'b1001);


wire check1, check2;

assign check1 = (regCompA == destReg) & (destReg != 4'h0);
assign check2 = (regCompB == destReg) & (destReg != 4'h0);

wire pc_stall_temp = (check1 | check2);
wire IF_DE_stall_temp = (check1 | check2);

assign RFBypassControl = (src1 == M_dst_reg | src2 == M_dst_reg) ? 1'b1 : 1'b0;

assign pc_stall = pc_stall_temp;
assign IF_DE_stall = IF_DE_stall_temp;

endmodule
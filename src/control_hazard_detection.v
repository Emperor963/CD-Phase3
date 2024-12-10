module control_hazard_detection(
    input [15:0] insn, // instruction from IF/Decode
    input regWriteX, //write instruction in X stage checks the regwrite from d/x
    input regWriteM, //write instruction in the M stage checks the regwrite from x/m
    input regWriteW, //write instruction in the W stage checks the regWrite from M/W
    input branch_taken,
    input [1:0] pc_source,


    input [3:0] destRegX,
    input [3:0] destRegM,
    input [3:0] destRegW,

    output pc_stall, //1 means stall the pc
    output IF_DE_stall //1 if to stall set to IF/ID resgister to output nop 
);

wire keyX, keyM, keyW, keyB, keyZ;
wire pc_flag = branch_taken;
//assigns measures reg to be read from Branch
wire [3:0] branchReg;
wire [3:0] compareRegX, compareRegM, compareRegW;

assign branchReg = insn[7:4];

assign keyB = (insn[15:12] == 4'b1101) & (branchReg != 4'b0000);

assign keyX = regWriteX;
assign keyM = regWriteM;
assign keyW = regWriteW;

assign keyZ = pc_flag & (pc_source == 2'b11 | pc_source == 2'b01);

assign compareRegX = (keyX) ? destRegX:4'b0000;
assign compareRegM = (keyM) ? destRegM:4'b0000;
assign compareRegW = (keyW) ? destRegW:4'b0000;



wire pc_stall_temp = (((compareRegX == branchReg) | (compareRegM == branchReg) | (compareRegW == branchReg)) & keyB);
wire IF_DE_stall_temp = (((compareRegX == branchReg) | (compareRegM == branchReg) | (compareRegW == branchReg)) & keyB) | keyZ;


assign pc_stall = pc_stall_temp;

assign IF_DE_stall = IF_DE_stall_temp;
endmodule


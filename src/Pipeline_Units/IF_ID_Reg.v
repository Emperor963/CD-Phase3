module IF_ID_Reg(
    input clk,
    input rst,
    input wren,
    input IFID_Flush,
    input[15:0] pc,
    input[15:0] instr,

    output [15:0] pc_out,
    output [15:0] instr_out
);

Register instrReg(.clk(clk), .rst(rst | IFID_Flush), .d(instr), .write_reg(wren), .ren1(1'b1), .ren2(1'b0), .bitline1(instr_out), .bitline2());
Register pcReg(.clk(clk), .rst(rst), .d(pc), .write_reg(wren | IFID_Flush), .ren1(1'b1), .ren2(1'b0), .bitline1(pc_out), .bitline2());

endmodule
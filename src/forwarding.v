module forwarding(

    input ALUSrc,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    input [3:0] ID_EX_Rt,
    input [3:0] ID_EX_Rs,

    input [3:0] EX_MEM_dst_reg,
    input [3:0] MEM_WB_dst_reg,


    output [1:0] LHControl,
    output [1:0] ALUControlA,
    output [1:0] ALUControlB );


    wire EX_RAW_A = (ID_EX_Rs == EX_MEM_dst_reg) & EX_MEM_RegWrite & (EX_MEM_dst_reg != 4'h0);
    wire EX_RAW_B = (ID_EX_Rt == EX_MEM_dst_reg) & EX_MEM_RegWrite & (EX_MEM_dst_reg != 4'h0);

    wire MEM_RAW_A = (ID_EX_Rs == MEM_WB_dst_reg) & MEM_WB_RegWrite & (MEM_WB_dst_reg != 4'h0) & (ID_EX_Rs != EX_MEM_dst_reg);
    wire MEM_RAW_B = (ID_EX_Rs == MEM_WB_dst_reg) & MEM_WB_RegWrite & (MEM_WB_dst_reg != 4'h0) & (ID_EX_Rs != EX_MEM_dst_reg);


    assign LHControl = EX_RAW_A ? 2'b10 :
                       MEM_RAW_A ? 2'b01 : 2'b00;
        

    assign ALUControlA = EX_RAW_A ? 2'b10 :
                         MEM_RAW_A ? 2'b01 : 2'b00;

    assign ALUControlB = ALUSrc ? 2'b01:
                         EX_RAW_B ? 2'b11 :
                         MEM_RAW_B ? 2'b01 : 2'b00;


endmodule
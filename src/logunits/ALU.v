module ALU(
    input [15:0] In1,
    input [15:0] In2,
    input [2:0] ALUOp,
    input [2:0] FLAG_in,

    output [2:0] FLAG,
    output [15:0] ALUOut
);

wire [15:0] sum, difference, pad, red, ror0, sll0, srl0, zor;

wire cAdd, cDiff, ovflAdd, ovflSub;

claAddSub addr(.A(In1), .Bin(In2), .Cin(1'b0), .isSub(1'b0), .S(sum), .Cout(cAdd), .ovfl(ovflAdd));
claAddSub subtrctr(.A(In1), .Bin(In2), .Cin(1'b0), .isSub(1'b1), .S(difference), .Cout(cAdd), .ovfl(ovflSub));
paddsb padder(.A(In1), .B(In2), .Sum(pad));
red reduction(.A(In1), .B(In2), .Sum(red));
ror rotate(.Ain(In1), .shamt(In2[3:0]), .Aout(ror0));
sll shiftL(.Ain(In1), .shamt(In2[3:0]), .Aout(sll0));
srl shiftR(.Ain(In1), .shamt(In2[3:0]), .Aout(srl0));
xor_module xorC(.A(In1), .B(In2), .X(zor));

wire[2:0] t1, t2, t3, t4, t5, t6, t7, t8;

assign t1 = (ALUOp ^ 3'b000);
assign t2 = (ALUOp ^ 3'b001);
assign t3 = (ALUOp ^ 3'b010);
assign t4 = (ALUOp ^ 3'b011);
assign t5 = (ALUOp ^ 3'b100);
assign t6 = (ALUOp ^ 3'b101);
assign t7 = (ALUOp ^ 3'b110);
assign t8 = (ALUOp ^ 3'b111);

wire tt1, tt2, tt3, tt4, tt5, tt6, tt7, tt8, tt9;

assign tt1 = !(t1[0] | t1[1] | t1[2]);
assign tt2 = !(t2[0] | t2[1] | t2[2]);
assign tt3 = !(t3[0] | t3[1] | t3[2]);
assign tt4 = !(t4[0] | t4[1] | t4[2]);
assign tt5 = !(t5[0] | t5[1] | t5[2]);
assign tt6 = !(t6[0] | t6[1] | t6[2]);
assign tt7 = !(t7[0] | t7[1] | t7[2]);
assign tt8 = !(t8[0] | t8[1] | t8[2]);



//Sorry I like ternary statements better than case

assign ALUOut = tt1 ? sum :
                tt2 ? difference:
                tt3 ? zor :
                tt4 ? red :
                tt5 ? sll0:
                tt6 ? srl0:
                tt7 ? ror0:
                tt8 ? pad :
                In1 & In2;


//FLAG[0] = N, FLAG[1] = V, FLAG[2] = Z
assign FLAG[0] = (tt1 | tt2) ? ALUOut[15]: 1'b0;
assign FLAG[1] = tt1 ? ovflAdd:
                 tt2 ? ovflSub: 
                 1'b0;
assign FLAG[2] = (ALUOut === 16'h0000) ? 1'b1 : 1'b0;

endmodule
module ror(
    input[15:0] Ain,
    input[3:0] shamt,

    output[15:0] Aout
);

wire[15:0] R1, R2, R4, R8; //temporary storage for individual rotation bits

assign R1 = shamt[0] ? {Ain[0] , Ain[15:1]} : Ain;
assign R2 = shamt[1] ? {R1[1:0], R1[15:2]} : R1;
assign R4 = shamt[2] ? {R2[3:0], R2[15:4]} : R2;
assign R8 = shamt[3] ? {R4[7:0] , R4[15:8]} :R4;

assign Aout = R8;


endmodule





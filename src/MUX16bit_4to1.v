module MUX16bit_4to1(
    input [15:0] sigA,
    input [15:0] sigB,
    input [15:0] sigC,
    input [15:0] sigD,

    input [1:0] control,

    output [15:0] out
);

wire[1:0] t1, t2, t3, t4; //temporary wires to store check values

assign t1 = ~(control ^ 2'b00);
assign t2 = ~(control ^ 2'b01);
assign t3 = ~(control ^ 2'b10);
assign t4 = ~(control ^ 2'b11);


assign out = (t1[0] & t1[1]) ? sigA :
             (t2[0] & t2[1]) ? sigB :
             (t3[0] & t3[1]) ? sigC :
             (t4[0] & t4[1]) ? sigD :
             16'bx; 


endmodule
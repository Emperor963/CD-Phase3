module MUX16bit_2to1(
    input [15:0] sigA,
    input [15:0] sigB,
    input control,

    output [15:0] out
);

assign out = control ? sigB : sigA;

endmodule
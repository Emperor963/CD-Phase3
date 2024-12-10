module xor_module (
    input [15:0]A,
    input [15:0]B,
    output [15:0]X
) ;

assign X = A ^ B;

endmodule
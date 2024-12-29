module srl(
    input [15:0] Ain,
    input [3:0] shamt,
    output [15:0] Aout
);

assign Aout = (shamt == 4'b0000) ? Ain :       // No shift
              (shamt == 4'b0001) ? (Ain >> 1) :
              (shamt == 4'b0010) ? (Ain >> 2) :
              (shamt == 4'b0011) ? (Ain >> 3) :
              (shamt == 4'b0100) ? (Ain >> 4) :
              (shamt == 4'b0101) ? (Ain >> 5) :
              (shamt == 4'b0110) ? (Ain >> 6) :
              (shamt == 4'b0111) ? (Ain >> 7) :
              (shamt == 4'b1000) ? (Ain >> 8) :
              (shamt == 4'b1001) ? (Ain >> 9) :
              (shamt == 4'b1010) ? (Ain >> 10) :
              (shamt == 4'b1011) ? (Ain >> 11) :
              (shamt == 4'b1100) ? (Ain >> 12) :
              (shamt == 4'b1101) ? (Ain >> 13) :
              (shamt == 4'b1110) ? (Ain >> 14) :
              (Ain >> 15);                    // Maximum shift (15 bits)

endmodule

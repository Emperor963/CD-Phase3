module srl(
    input [15:0] Ain,
    input [3:0] shamt,
    output [15:0] Aout
);

    wire [15:0] sign_extend;

    // Generate a mask with the sign bit replicated
    assign sign_extend = {16{Ain[15]}}; // Replicates the MSB (sign bit) 16 times

    // Perform logical shift and combine with sign extension
    assign Aout = (Ain >> shamt) | (sign_extend & ~(16'hFFFF >> shamt));

endmodule

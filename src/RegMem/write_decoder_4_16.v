module write_decoder_4_16(
    input [3:0] reg_id,
    input write_reg,
    output [15:0] wordline
);

wire [15:0] sample;

assign sample = 16'h1;

wire [15:0] shift;

sll shifter(.Ain(sample), .shamt(reg_id), .Aout(shift));

assign wordline = !(write_reg ^ 0) ?  16'h0 : shift; //CHANGE TO CONST SHAMTS

endmodule
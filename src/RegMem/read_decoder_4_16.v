module read_decoder_4_16(
    input [3:0] reg_id,
    output[15:0] wordline
);

wire [15:0] sample;
assign sample = 16'h1;

//assign wordline = sample << reg_id; //NEED TO CHANGE THIS TO CONSTANT SHAMTS

sll shifter(.Ain(sample), .shamt(reg_id), .Aout(wordline));

endmodule;
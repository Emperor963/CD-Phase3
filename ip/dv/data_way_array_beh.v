// ECE/CS 552 Data Array Design File (Behaviorial)
// Data Array with 64 sets
// Each set will have 8 words
// set_enable and word_enable are one-hot
// wen is 1 on writes and 0 on reads

module data_way_array_beh (
    input clk,
    input rst,
    input [15:0] data_in,
    input wen,
    input [63:0] set_enable,
    input [7:0] word_enable,
    output [15:0] data_out
);
  logic [6:0] set_index;
  logic [2:0] word_index;
  logic [15:0] sets[64][8];

  assign data_out = |set_enable & |word_enable ? sets[set_index][word_index] : 16'hz;

  always_comb begin
    set_index = -1;
    for (int i = 0; i < 64; i++) begin
      if (set_enable[i]) begin
        set_index = i;
        //break;
      end
    end
    word_index = -1;
    for (int j = 0; j < 8; j++) begin
      if (word_enable[j]) begin
        word_index = j;
        //break;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < 64; i++) for (int j = 0; j < 8; j++) sets[i][j] <= 0;
    end else begin
      if (wen & |set_enable & |word_enable) sets[set_index][word_index] <= data_in;
    end
  end
endmodule

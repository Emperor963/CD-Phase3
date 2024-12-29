// ECE/CS 552 Metadata (aka Tag) Array Design File
// Tag Array with 64 sets
// Each set stores 8 bits for tag, valid, and LRU bit.
// set_enable is one-hot
// wen is 1 on writes and 0 on reads

module metadata_way_array_beh (
    input clk,
    input rst,
    input [7:0] data_in,
    input wen,
    input [63:0] set_enable,
    output [7:0] data_out
);
  logic [7:0] sets[64];
  logic [6:0] set_index;
  assign data_out = |set_enable ? sets[set_index] : 8'hz;

  always_comb begin
    for (int i = 0; i < 64; i++) begin
      if (set_enable[i]) begin
        set_index = i;
        //break;
      end
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      for (int i = 0; i < 64; i++) sets[i] <= 0;
    end else begin
      if (wen & |set_enable) sets[set_index] <= data_in;
    end
  end
endmodule

// ECE/CS 552 Metadata (aka Tag) Array Design File
// Tag Array with 64 sets
// Each set stores 8 bits for tag, valid, and LRU bit.
// set_enable is one-hot
// wen is 1 on writes and 0 on reads

module metadata_way_array (
    input clk,
    input rst,
    input [7:0] data_in,
    input wen,
    input [63:0] set_enable,
    output [7:0] data_out
);
  cache_word #(
      .WIDTH(8)
  ) sets[63:0] (
      .clk(clk),
      .rst(rst),
      .data_in(data_in),
      .wen(wen),
      .enable(set_enable),
      .data_out(data_out)
  );
endmodule

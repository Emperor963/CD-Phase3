`timescale 1ns / 1ns `default_nettype none

module arrays_tb ();

  integer cnt;
  reg clk, rst, meta_wen, data_wen;
  initial begin
    clk <= 1'b0;
    forever #5 clk <= ~clk;
  end

  reg [7:0] meta_shadow[64];  // 8 bits wide, 64 sets
  reg [15:0] data_shadow[64][8];  // 16 bits wide, 64 sets, 8 words per set

  reg go_random;
  reg [63:0] set_enable;
  reg [7:0] word_enable;
  reg [15:0] data_in;
  reg meta_active;
  reg data_active;
  wire [15:0] data_out, data_shadow_out;
  wire [7:0] metadata_out, meta_data_in, meta_shadow_out;
  integer i, j, k, set, word;

  always @(posedge clk) begin
    if (rst) begin
      for (i = 0; i < 64; i = i + 1) begin
        meta_shadow[i] <= '0;
        for (j = 0; j < 64; j = j + 1) begin
          data_shadow[i][j] <= '0;
        end
      end
    end else begin
      if (data_wen) data_shadow[set][word] <= data_in;
      if (meta_wen) meta_shadow[set] <= meta_data_in;
    end
  end
  assign meta_shadow_out = ~rst & ~meta_wen ? meta_shadow[set] : 'hx;
  assign data_shadow_out = ~rst & ~data_wen ? data_shadow[set][word] : 'hx;

  always @(posedge clk) begin
    if (!rst) begin
      if (!meta_wen) begin
        if (meta_shadow_out !== metadata_out) begin
          $display("%0t metadata_way_array read failed; got 0x%x wanted 0x%x", $time, metadata_out,
                   meta_shadow_out);
          $finish;
        end
      end
      if (!data_wen) begin
        if (data_shadow_out !== data_out) begin
          $display("%0t data_way_array read failed; got 0x%x wanted 0x%x", $time, data_out,
                   data_shadow_out);
          $finish;
        end
      end
    end
  end

  initial begin
    $dumpvars;
    rst <= 1'b1;
    go_random <= 1'b0;
    meta_active <= 1'b0;
    data_active <= 1'b0;
    data_wen <= 1'b0;
    meta_wen <= 1'b0;
    set_enable <= 64'h1;
    word_enable <= 8'h1;
    data_in <= '0;
    cnt <= 0;
    repeat (3) @(posedge clk);
    rst <= 1'b0;

    repeat (2) @(posedge clk);
    // Directed cases
    // Fill metadata
    meta_active <= 1'b1;
    for (i = 0; i < 63; i = i + 1) begin
      meta_wen <= 1'b1;
      set_enable <= 1'b1 << i;
      word_enable <= 8'h1;
      @(posedge clk);
    end

    // Read metadata
    for (i = 0; i < 63; i = i + 1) begin
      meta_wen <= 1'b0;
      set_enable <= 1'b1 << i;
      word_enable <= 8'h1;
      @(posedge clk);
    end

    // Fill data
    meta_active <= 1'b0;
    data_active <= 1'b1;
    for (i = 0; i < 512; i = i + 1) begin
      data_wen <= 1'b1;
      set_enable <= 1'b1 << i[8:3];
      word_enable <= 1'b1 << i[2:0];
      @(posedge clk);
    end

    // Read data
    for (i = 0; i < 512; i = i + 1) begin
      data_wen <= 1'b0;
      set_enable <= 1'b1 << i[8:3];
      word_enable <= 1'b1 << i[2:0];
      @(posedge clk);
    end

    go_random   <= 1'b1;
    meta_active <= 1'b1;
  end

  always @(posedge clk) begin
    cnt <= cnt + 1;
    data_in <= $urandom;


    if (go_random) begin
      set_enable <= 1'b1 << $urandom_range(0, 63);
      word_enable <= 1'b1 << $urandom_range(0, 7);
      meta_wen <= $urandom;
      data_wen <= $urandom;
    end

    if (cnt > 1300) $finish;
  end

  assign meta_data_in = data_in[11:4];

  metadata_way_array metadata_way_array (
      .clk(clk),
      .rst(rst),
      .data_in(meta_data_in),
      .wen(meta_wen),
      .set_enable(set_enable),
      .data_out(metadata_out)
  );

  data_way_array data_way_array (
      .clk(clk),
      .rst(rst),
      .data_in(data_in),
      .wen(data_wen),
      .set_enable(set_enable),
      .word_enable(word_enable),
      .data_out(data_out)
  );

  always @(*) begin
    for (j = 0; j < 8; j = j + 1) begin
      if (word_enable[j]) word = j;
    end
    for (j = 0; j < 64; j = j + 1) begin
      if (set_enable[j]) set = j;
    end
  end

  // Log to screen
  always @(posedge clk) begin
    if (!rst) begin
      // Metadata
      if (meta_wen) $display("%t metadata writing 0x%x to set %0d", $time, meta_data_in, set);
      else if (meta_active)
        $display("%t metadata reading 0x%x from set %0d", $time, metadata_out, set);
      // Data
      if (data_wen) $display("%t data writing 0x%x to set %0d word %0d", $time, data_in, set, word);
      else if (data_active)
        $display("%t data reading 0x%x from set %0d word %0d", $time, data_out, set, word);
    end
  end
endmodule  // arrays_tb

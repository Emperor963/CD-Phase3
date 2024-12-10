// Testbench for memory4c.v
`default_nettype none

module memory4c_tb ();

  reg clk;
  integer clk_cnt = 0;
  initial begin
    clk = 1'b0;
    forever #5 clk <= ~clk;
  end

  reg rst;
  always @(posedge clk) begin
    clk_cnt <= rst ? 0 : clk_cnt + 1;
  end

  wire [15:0] data_out;
  wire        data_valid;
  reg  [15:0] data_in;
  reg  [15:0] addr;
  reg         enable;
  reg         wr;

  /*
  initial
    $monitor(
        "clk=%d addr=0x%h data_in=0x%h data_out=0x%h wr=%h enable=%h rst=%h",
        clk_cnt,
        addr,
        data_in,
        data_out,
        wr,
        enable,
        rst
    );
    */

  wire [15:0] data3 = mem.data_out_pl[3];
  wire [15:0] data2 = mem.data_out_pl[2];
  wire [15:0] data1 = mem.data_out_pl[1];
  wire [15:0] data0 = mem.data_out_pl[0];

  always @(posedge clk) begin
    if (!rst) begin
      if (enable & wr) $display("%0d: %m write mem[0x%x] <= 0x%x", clk_cnt, addr, data_in);
      if (enable & ~wr) $display("%0d: %m read mem[0x%x]", clk_cnt, addr);
      if (data_valid) $display("%0d: %m memory4c returned data 0x%x", clk_cnt, data_out);
    end
  end

  integer i;
  initial begin
    $dumpvars;
    rst <= 1'b1;
    data_in <= 16'h0;
    addr <= 16'h0;
    enable <= 1'b0;
    wr <= 1'b0;

    repeat (2) @(posedge clk);
    rst <= 1'b0;
    repeat (2) @(posedge clk);

    $display("Starting...");
    // write value 'i' to address 'i'
    $display("%0t write value 'i' to address 'i'.", $time);
    enable <= 1'b1;
    wr <= 1'b1;
    for (i = 0; i < 8; i++) begin
      addr <= {i[14:0], 1'b0};
      data_in <= i[15:0];
      @(posedge clk);  // wait for next clock
    end

    // Read all addresses and compare. Note data_out will lag by 4 clocks.
    $display("%0t read all addresses.", $time);
    enable <= 1'b1;
    wr <= 1'b0;
    for (i = 0; i < 8; i++) begin
      data_in <= 16'hxxxx;
      addr <= {i[14:0], 1'b0};
			//enable <= (i == 7) ? 1'b0 : enable; 
      @(posedge clk);
    end
    enable <= 1'b0;
    repeat (10) @(posedge clk);  // Flush memory4c pipeline

    // Write/Read random addresses.
    $display("%0t random read/write.", $time);
    for (i = 0; i < 20; i++) begin
      enable <= $urandom_range(0, 7) > 0;
      wr <= $urandom();
      data_in <= $urandom();
      addr <= {$urandom_range(0, 7), 1'b0};
      @(posedge clk);
    end
    enable <= 1'b0;

    repeat (10) @(posedge clk);  // Flush memory4c pipeline
    $writememh("mem_out.img", mem.mem);
    $finish;
  end

  memory4c #(
      .DWIDTH(16),
      .AWIDTH(16)
  ) mem (
      .data_out(data_out),
      .data_valid(data_valid),
      .data_in(data_in),
      .addr(addr),
      .enable(enable),
      .wr(wr),
      .clk(clk),
      .rst(rst)
  );

endmodule  // memory1c_tb

`timescale 1ns / 1ps

// Top-level testbench for ECE 552 cpu.v Phase 2
module phase3_cpu_tb ();
  localparam half_cycle = 50;

  // Signals that interface to the DUT.
  wire [15:0] PC;
  wire Halt;  /* Halt executed and in Memory or writeback stage */
  reg clk;  /* Clock input */
  reg rst;  /* (Active high) Reset input */

  // Instantiate the processor as Design Under Test.
  cpu DUT (
      .clk(clk),
      .rst(rst),
      .pc (PC),
      .hlt(Halt)
  );

  initial begin
    clk <= 1;
    forever #half_cycle clk <= ~clk;
  end

  initial begin
    rst <= 1;  /* Intial reset state */
    repeat (4) @(posedge clk);
    rst <= 0;
  end

  // Assign internal signals - See wisc_trace_p3.v for instructions.
  // Edit the example below. You must change the signal names on the right hand side to match your naming convention.
  wisc_trace_p3 wisc_trace_p3 (
      .clk(clk),
      .rst(rst),
      .PC(PC),
      .Halt(Halt),
      .Inst(DUT.instruction),
      .RegWrite(DUT.RF.write_reg),
      .WriteRegister(DUT.RF.dst_reg),
      .WriteData(DUT.RF.dst_data),
      .MemRead(DUT.MemRead),
      .MemWrite(DUT.MemWrite),
      .MemAddress(DUT.CacheData.d_addr),
      .MemDataIn(DUT.CacheData.cpu_data_in),
      .MemDataOut(DUT.DMem_Read),
      .icache_req(DUT.CacheData.i_ren),
      .icache_hit(~DUT.ic_miss),
      .dcache_req(DUT.CacheData.d_ren),
      .dcache_hit(~DUT.dc_miss)
  );

  /* Add anything else you want here */

endmodule

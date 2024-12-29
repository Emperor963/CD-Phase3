module cache_wrapper(
    input clk,
    input rst,
    input [15:0] i_addr,
    input i_ren,
    input i_wren,

    output[15:0] i_out,

    input[15:0] d_addr,
    input[15:0] cpu_data_in,
    input d_ren,
    input d_wren,

    output[15:0] d_out,
    output icache_miss,
    output dcache_miss,

    output fsm_busy
);

wire [15:0] i_addr_input, i_data_in, d_addr_input, d_data_in, i_data_out, d_data_out, mem_addr4L2, L2_data_out, fsm_write_data, L2_addr, L2_data_in, fsm_write_addr, fsm_addr_final;
wire [15:0] l2_addr_return;
wire i_wr, i_rewrite, i_miss, d_wr, d_rewrite, d_miss, fsmbusy, i_wren_fsm, d_wren_fsm, i_en, d_en, fsm_en_out, L2_valid, fsm_isWriting, fsm_validbit;
wire l2_enable, l2_wren;


assign i_en = i_ren;
assign d_en = d_ren;


//WREN SIGNALS FOR CACHE IS 0 FOR READS, 1 FOR WRITES
assign i_wr = (i_en & ~i_miss) ? 1'b0 : 
              i_wren_fsm ? i_wren_fsm : i_wren; //i_wren from cpu should always be 0. Further there can't be two i-cache misses queued at the same time.

assign d_wr = (d_en & ~d_miss) ? 1'b0:
              d_wren_fsm ? d_wren_fsm  : d_wren; //d_wren from cpu is 1 for sw insns. D-cache can be queued, but no write through may occur when the fsm is actively busy
                                                 // fetching data. Ideally you'd want to check for fsm writing into icache but for any read through cases write enable of L2 will be 0.



//Note: an integral part of our design was to use the LSB port as the input for valid bit (since port 0 is always zero for 2B half-words)
assign i_data_in = i_wren_fsm ? fsm_write_data : 16'h0000; // the else portion should be unreachable logically to the ICache because i_wren will be 0 if !fsmbusy
assign d_data_in = i_wren_fsm ? fsm_write_data : cpu_data_in; //for sw hits, d_miss shouldn't happen


assign fsm_addr_final = {fsm_write_addr[15:1], fsm_validbit};

assign i_addr_input = i_wren_fsm ? fsm_addr_final : i_addr;
assign d_addr_input = d_wren_fsm ? fsm_addr_final : d_addr;

assign i_rewrite = i_wren_fsm ? fsm_isWriting : 1'b0;
assign d_rewrite = d_wren_fsm ? fsm_isWriting : 1'b0;


assign i_out = i_data_out;
assign d_out = d_data_out;

assign l2_en = (fsmbusy | d_wren) ? 1'b1 : 1'b0; //If FSM isn't reading or CPU isn't writing, it need not be enabled
assign l2_wren = (d_wren & ~fsmbusy); // If CPU is writing, write_enable cant be turned on since FSM will NEVER write into L2. If CPU isn't writing, nobody is.
assign L2_addr = ~l2_wren ? mem_addr4L2 : d_addr; // If fsm is busy, that means FSM is reading and CPU can't write into L2 hit or not
assign L2_data_in = d_data_in; //Only CPU writes into L2


assign icache_miss = i_miss;
assign dcache_miss = d_miss;
 

cache ICache(.clk(clk), .rst(rst), .memAddr(i_addr_input), .data_in(i_data_in), .wren(i_wr), .rewrite(i_rewrite), .rd_data_out(i_data_out), .cache_miss(i_miss));
cache DCache(.clk(clk), .rst(rst), .memAddr(d_addr_input), .data_in(d_data_in), .wren(d_wr), .rewrite(d_rewrite), .rd_data_out(d_data_out), .cache_miss(d_miss));




cache_fsm controller(.clk(clk), .rst(rst), .icache_miss(i_miss), .dcache_miss(d_miss), .imiss_addr(i_addr), .dmiss_addr(d_addr), .fsmbusy(fsmbusy), 
                     .d_wren(d_wren_fsm), .i_wren(i_wren_fsm), .mem_addr(mem_addr4L2), .mem_en(fsm_en_out), .l2_data(L2_data_out), .l2_valid(L2_valid), 
                     .l2_addr(l2_addr_return), .write_data(fsm_write_data), .write_address(fsm_write_addr), .isWriting(fsm_isWriting), .validbit(fsm_validbit));


memory4c L2Shared(.data_out(L2_data_out), .data_valid(L2_valid), .addr_out(l2_addr_return), .data_in(L2_data_in), .addr(L2_addr), .enable(l2_en), .wr(l2_wren), .clk(clk), .rst(rst));

assign fsm_busy = fsmbusy;



endmodule
module cache_fsm(
    input clk,
    input rst, 
    input icache_miss, //active high when tag match logic detects a miss in i cache
    input dcache_miss, //active high when tag match logic detects a miss in d cache
    input [15:0] imiss_addr, //address that missed the i-cache
    input [15:0] dmiss_addr, //address that missed the d-cache

    output fsmbusy, //asserted while FSM is busy handling the miss (can be used as a pipeline stall sig)
    output d_wren, // unified write enable signal for d data array
    output i_wren, // wren for icache

    output [15:0] mem_addr,
    output mem_en,
    input [15:0] l2_data, //data returned by memory (after delay)
    input l2_valid, // valid bit output from shared l2 cache
    input [15:0] l2_addr,

    output [15:0] write_data, //data to write into the cache
    output [15:0] write_address,
    output isWriting,
    output validbit

);


wire [3:0] packets_curr, packets_updated, req_curr, req_upd;
wire miss_detected, receiving_data, idle_out, busy_out, packet_ctr_rst, request_successful;
wire STATE_trigger;
wire ptr, ptr_in;
wire[15:0] stack1_readout, stack2_readout, actual_readout;
wire [15:0] cpu_miss_request, memory_request_address;



assign miss_detected = icache_miss | dcache_miss; // There's a cache miss if either of the caches have missed. Useful for my state transition logic.
assign receiving_data = l2_valid; //as long as l2 valid is 1, we are receiving good data
//*assign IDLE_trigger = /*~(idle_out) & ~(receiving_data) & ~busy_out; //Trigger reset logic for IDLE ff
//assign BUSY_trigger = ~(busy_out) & (miss_detected | receiving_data); //Trigger reset logic for BUSY ff*/
assign STATE_trigger = miss_detected & ~packet_ctr_rst;
assign packet_ctr_rst = packets_curr[0] & packets_curr[1] & packets_curr[2]; //packet counter gotta reset every eight packets
assign req_ctr_rst = req_curr[0] & req_curr[1] & req_curr[2]; //request counter also gotta reset every eight packets
assign actual_readout = ptr ? stack2_readout : stack1_readout; // easy mux to choose which stack to read from presently
assign ptr_in = req_ctr_rst ? ~ptr : ptr; //basically keep pointing at the same stack element unless the request counter is done counting.
assign cpu_miss_request = icache_miss ? imiss_addr : dcache_miss? dmiss_addr : 16'hFFFF; //is it an i-miss? is it a d-miss? 16'hFFFF is the default "no request" address


// STATE HANDLING LOGIC
dff IDLE(.clk(clk), .rst(rst | STATE_trigger), .q(idle_out), .d(1'b1), .wen(~STATE_trigger));
dff BUSY(.clk(clk), .rst(rst | ~STATE_trigger), .q(busy_out), .d(1'b1), .wen(STATE_trigger));

Register4 packets_received(.clk(clk), .rst(rst | packet_ctr_rst), .out(packets_curr), .d(packets_updated), .wen(l2_valid));
Register4 requests_sent(.clk(clk), .rst(rst | req_ctr_rst), .out(req_curr), .d(req_upd), .wen(request_successful));



//NOTE: If the ptr variable is at pointing at Stack0, it means that Stack0 is the memory request we're handling right now. This means no new requests should overwrite Stack0
// (hence ptr is the wren for this reg) and the read enable for the register should be ON (hence the negation of ptr). The exact opposite goes for Stack1. I think this logic works (final update: 12/16)


Register Stack0(.clk(clk), .rst(rst | (~ptr & req_ctr_rst)), .d(cpu_miss_request), .write_reg(ptr), .ren1(~ptr), .ren2(1'b0), .bitline1(stack1_readout), .bitline2());      
                        //stack to store existing requests. A simplifying assumption is that for the pipeline, we do not have
Register Stack1(.clk(clk), .rst(rst | (ptr & req_ctr_rst)), .d(cpu_miss_request), .write_reg(~ptr), .ren1(ptr), .ren2(1'b0), .bitline1(stack2_readout), .bitline2());      
                        // more than two pending requests at any given moment. This works because when I-Cache stalls, the whole 
                        // cpu must be stalled and no two I-Cache misses can occur simultaneously. On the other hand, there MAY be an I-Cache
                        // D-cache miss within a few cycles of one another. If the D miss is at M stage and I-miss at F, then the odds of another cache miss in D
                        // between F and M will be handled by the cpu controller. An I-Cache miss happening before a D-miss is also similarly handled, but hopefully is never
                        // the issue. However, this can be solved with a longer buffer stack, I just don't want to create a complex stack ptr logic. 

dff stack_ptr(.clk(clk), .rst(rst), .q(ptr), .d(ptr_in), .wen(req_ctr_rst & miss_detected)); // the wen could very well be just 1'b1 but extra protection I suppose

adder_4bit packet_ctr(.A(packets_curr), .B(4'h1), .C(1'b0), .Sum(packets_updated), .Cout(), .P(), .G(), .ovfl());
adder_4bit request_ctr(.A(req_curr), .B(4'd1), .C(1'b0), .Sum(req_upd), .Cout(), .P(), .G(), .ovfl());




/** PREFETCHING TEST
wire prefetch_en; 
reg [15:0] prefetch_addr; 

// Enable prefetching only when the FSM is idle and the last request was a miss
assign prefetch_en = ~fsmbusy & miss_detected;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        prefetch_addr <= 16'h0000; 
    end else if (prefetch_en) begin
        prefetch_addr <= cpu_miss_request + 16'h0010; 
    end
end


// Integrate prefetch into memory requests
assign memory_request_address = (fsmbusy) ? actual_readout : prefetch_addr;
assign mem_en = (fsmbusy | prefetch_en) ? 1'b1 : 1'b0; // Enable memory for FSM or prefetch*/



// DATA EXCHANGE LOGIC (final fixes: 12/17)

//TODO: Take the actual read_out from the stack, switch it's offset to necessary offset and send it to the memory. Whatever you receive from memory, send to cache along with
//write_data and validbit ports

assign memory_request_address = {actual_readout[15:4], req_curr[2:0], 1'b0};
assign mem_en = (idle_out | actual_readout == 16'hFFFF) ? 1'b0 : 1'b1;
assign request_successful = fsmbusy;





//output ports for caches
assign d_wren = dcache_miss & busy_out & l2_valid; 
assign i_wren = icache_miss & busy_out & l2_valid;
assign fsmbusy = busy_out;
assign validbit = l2_valid & (packet_ctr_rst);
assign write_data = l2_data;
assign isWriting = ~packet_ctr_rst;
assign write_address = l2_addr;

//output port for memory
assign mem_addr = memory_request_address;


endmodule
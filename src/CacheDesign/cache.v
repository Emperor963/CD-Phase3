
module cache (
    input clk,
    input rst,
    input [15:0] memAddr, // from cpu
    input [15:0] data_in, //from memory
    //input valid,  //from memory
    input wren, // control signal
    input valid,
    
    output [15:0] data_out,
    output cache_miss
);



// SET APPROPRIATE BUSES
wire [7:0] tag; //incoming tag
wire [5:0] set_index; //incoming set index
wire [2:0] offset; //incoming offset
wire [63:0] set_enable; //set_enable decoders

wire [7:0] Way0, Way2; //tag array of given ways
wire [7:0] word_enable; // enabler for wordline in data_way_block *******

wire [15:0] data_in0, data_in1; //seperate wire fore each data way
wire [15:0] data_out0, data_out1; //seperate wires to select between wire

wire wren0, wren1;
wire cache_hit0;
wire cache_hit1;


//ASSIGN BUSSES

assign tag0[7:2] = (rewrite0) ? memAddr[15:10]:Way0[8:2];
assign tag0[1] = lru0_ass;
assign tag0[0] = (rewrite0) 1'b0:memAddr[0];

assign tag1[7:2] = (rewrite1) ? memAddr[15:10]:Way1[8:2];
assign tag1[1] = lru1_ass;
assign tag1[0] = (rewrite1) ? 1'b0:memAddr[0];

assign set_index = memAddr[9:4];
assign offset = memaddr[3:1];

assign lru0 = Way0[1];
assign lru1 = Way1[1];
assign valid0 = Way0[0];
assign valid1 = Way1[1];


//check for cache miss
assign cache_miss = !((tag0 == Way0) | (tag1 = Way1));
assign cache_hit0 = tag0[7:2] == Way0[7:2];
assign cache_hit1 = tag1[7:2] == Way1[7:2];

assign rewrite0 = (cache_miss & lru0 | !valid0) | (cache_hit0 & wren);
assign rewrite1 = (cache_miss & lru1 | !valid1) | (cache_hit1 & wren);

wire lru0_ass = !cache_hit0 | !rewrite0; //lru if not a cache hit and no rewrite selected
wire lru1_ass = !lru0_ass ; //needs logic for lru when written

//tag to be written in 

//asigning buses


//when to rewrite cache
assign wren0 = (lru0 != lru0_ass) | rewrite0;
assign wren1 = (lru1 != lru1_ass) | rewrite1;

//different types of writes lru update on a cache access (read or write), write on cache_hit, eviction on a cache miss.



//instantiate Meta data array here
metadata_way_array MDW0 (.clk(clk), rst(rst), data_in(tag0), wen(wren1), set_enable(set_enable0), data_out(Way0));
metadata_way_array MDW1 (.clk(clk), rst(rst), data_in(tag1), wen(wren1), set_enable(set_enable0), data_out(Way1));

//Instantiate Data array here
data_way_arra DW0 (.clk(clk), .rst(rst), .data_in(data_in0), .wen(wren0), .enable(set_enable1), .word_enable(word_enable), data_out(data_out0));
data_way_arra DW0 (.clk(clk), .rst(rst), .data_in(data_in1), .wen(wren1), .enable(set_enable1), .word_enable(word_enable), data_out(data_out1));


//Data Access section
//implement Cache lookup




//Cache Miss
//load new data from memory


//set LRU


//Write
//check wren and write data and set valid bit





endmodule





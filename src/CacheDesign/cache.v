module cache (
    input clk,
    input rst,
    input [15:0] memAddr, // from cpu
    input [15:0] data_in, //from memory
    input wren, // control signal
    input rewrite,
    
    output [15:0] data_out,
    output cache_miss
);
//literally nobody else will be able to understand this and im sorry

wire [5:0] in_tag; //compare to current tag
wire [7:0] tag0; //tag to write in to MDA0
wire [7:0] tag1; //tag to write in to MDA1
wire [7:0] Way0, Way1; //load current tags in data array
wire cache_hit0, cache_hit1;
//wire cache_miss;
//wire lru;
wire wren0, wren1;
wire valid;
wire dwren0, dwren1;
wire [15:0] data_out0, data_out1;
wire [5:0]set_index;
wire [63:0]set_enable;
wire [7:0]word_enable;


assign set_index = memAddr[9:4];

assign valid = (cache_miss & !rewrite) ? 1'b0:(memAddr[0]);  //hopefully, fsm will be providing a valid bit of 1 for regular instructions

assign in_tag = memAddr[15:10]; //assign in tag

//check for cache miss. 
assign cache_hit0 = (in_tag == Way0[7:2]) & Way0[1]; // checks if tags match and block is valid
assign cache_hit1 = (in_tag == Way1[7:2]) & Way1[1]; //checks if tags match and block is valid
assign cache_miss = !(cache_hit0 | cache_hit1); //neither match

assign lru = cache_hit0 ? 1'b1 : 
             cache_hit1 ? 1'b0 :
             Way0[0]; // Default to Way0's LRU bit when no hit


//check lru
//lru bits stored in 1 bit of Way0

assign wren0 = ((lru != Way0[0]) & !cache_miss) | (cache_miss & !Way0[0]); // only write is lru is not 
assign wren1 = (cache_miss & Way0[0]);

assign tag0 = (!cache_miss) ? {Way0[7:1],lru}:{in_tag,valid,lru}; //if there is a cache hit update the lru but keep the say data, if there is a cache miss write in the tag but mark the block as invalid
assign tag1 = {in_tag, valid, 1'b1}; // if there is a cache miss write in the tag but mark the block as invalid.

assign data_out = (cache_hit0) ? data_out0:data_out1;

assign dwren0 = (cache_hit0 & wren) | (cache_miss & !Way0[0]);
assign dwren1 = (cache_hit1 & wren) | (cache_miss &  Way0[0]);


//instantiate Meta data array here
metadata_way_array MDW0 (.clk(clk), .rst(rst), .data_in(tag0), .wen(wren0), .set_enable(set_enable), .data_out(Way0));
metadata_way_array MDW1 (.clk(clk), .rst(rst), .data_in(tag1), .wen(wren1), .set_enable(set_enable), .data_out(Way1));

//Instantiate Data array here
data_way_array DW0 (.clk(clk), .rst(rst), .data_in(data_in), .wen(dwren0), .set_enable(set_enable), .word_enable(word_enable), .data_out(data_out0));
data_way_array DW1 (.clk(clk), .rst(rst), .data_in(data_in), .wen(dwren1), .set_enable(set_enable), .word_enable(word_enable), .data_out(data_out1)); 


//Set enable decode logic

assign set_index = memAddr[9:4]; // Use bits [9:4] for set index

assign set_enable[0] = (set_index == 6'd0);
assign set_enable[1] = (set_index == 6'd1);
assign set_enable[2] = (set_index == 6'd2);
assign set_enable[3] = (set_index == 6'd3);
assign set_enable[4] = (set_index == 6'd4);
assign set_enable[5] = (set_index == 6'd5);
assign set_enable[6] = (set_index == 6'd6);
assign set_enable[7] = (set_index == 6'd7);
assign set_enable[8] = (set_index == 6'd8);
assign set_enable[9] = (set_index == 6'd9);
assign set_enable[10] = (set_index == 6'd10);
assign set_enable[11] = (set_index == 6'd11);
assign set_enable[12] = (set_index == 6'd12);
assign set_enable[13] = (set_index == 6'd13);
assign set_enable[14] = (set_index == 6'd14);
assign set_enable[15] = (set_index == 6'd15);
assign set_enable[16] = (set_index == 6'd16);
assign set_enable[17] = (set_index == 6'd17);
assign set_enable[18] = (set_index == 6'd18);
assign set_enable[19] = (set_index == 6'd19);
assign set_enable[20] = (set_index == 6'd20);
assign set_enable[21] = (set_index == 6'd21);
assign set_enable[22] = (set_index == 6'd22);
assign set_enable[23] = (set_index == 6'd23);
assign set_enable[24] = (set_index == 6'd24);
assign set_enable[25] = (set_index == 6'd25);
assign set_enable[26] = (set_index == 6'd26);
assign set_enable[27] = (set_index == 6'd27);
assign set_enable[28] = (set_index == 6'd28);
assign set_enable[29] = (set_index == 6'd29);
assign set_enable[30] = (set_index == 6'd30);
assign set_enable[31] = (set_index == 6'd31);
assign set_enable[32] = (set_index == 6'd32);
assign set_enable[33] = (set_index == 6'd33);
assign set_enable[34] = (set_index == 6'd34);
assign set_enable[35] = (set_index == 6'd35);
assign set_enable[36] = (set_index == 6'd36);
assign set_enable[37] = (set_index == 6'd37);
assign set_enable[38] = (set_index == 6'd38);
assign set_enable[39] = (set_index == 6'd39);
assign set_enable[40] = (set_index == 6'd40);
assign set_enable[41] = (set_index == 6'd41);
assign set_enable[42] = (set_index == 6'd42);
assign set_enable[43] = (set_index == 6'd43);
assign set_enable[44] = (set_index == 6'd44);
assign set_enable[45] = (set_index == 6'd45);
assign set_enable[46] = (set_index == 6'd46);
assign set_enable[47] = (set_index == 6'd47);
assign set_enable[48] = (set_index == 6'd48);
assign set_enable[49] = (set_index == 6'd49);
assign set_enable[50] = (set_index == 6'd50);
assign set_enable[51] = (set_index == 6'd51);
assign set_enable[52] = (set_index == 6'd52);
assign set_enable[53] = (set_index == 6'd53);
assign set_enable[54] = (set_index == 6'd54);
assign set_enable[55] = (set_index == 6'd55);
assign set_enable[56] = (set_index == 6'd56);
assign set_enable[57] = (set_index == 6'd57);
assign set_enable[58] = (set_index == 6'd58);
assign set_enable[59] = (set_index == 6'd59);
assign set_enable[60] = (set_index == 6'd60);
assign set_enable[61] = (set_index == 6'd61);
assign set_enable[62] = (set_index == 6'd62);
assign set_enable[63] = (set_index == 6'd63);

// Extract block_offset from memAddr
wire [2:0] block_offset; // 3-bit block offset
assign block_offset = memAddr[3:1]; // Use bits [3:1] for block offset


assign word_enable[0] = (block_offset == 3'd0);
assign word_enable[1] = (block_offset == 3'd1);
assign word_enable[2] = (block_offset == 3'd2);
assign word_enable[3] = (block_offset == 3'd3);
assign word_enable[4] = (block_offset == 3'd4);
assign word_enable[5] = (block_offset == 3'd5);
assign word_enable[6] = (block_offset == 3'd6);
assign word_enable[7] = (block_offset == 3'd7);



endmodule

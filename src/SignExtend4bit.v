module SignExtend4bit (
    input [3:0]A,
    output [15:0]B
);   

assign B = { {12{A[3]}}, A};


endmodule
module SignExtend8bit (
    input [7:0]A,
    output [15:0]B
);   

assign B = { {12{A[7]}}, A};


endmodule
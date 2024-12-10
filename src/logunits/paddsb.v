module paddsb (
    input [15:0] A,
    input [15:0] B,

    output [15:0] Sum
);


wire [15:0]tempSum;

wire [3:0]ovfl;
wire [3:0]Cout;

wire dummy1, dummy2;

adder_4bit add0 (.A(A[15:12]), .B(B[15:12]), .C(1'b0), .Sum(tempSum[15:12]), .Cout(Cout[0]), .P(dummy1), .G(dummy2), .ovfl(ovfl[3]));
adder_4bit add1 (.A(A[11:8]), .B(B[11:8]), .C(1'b0), .Sum(tempSum[11:8]), .Cout(Cout[1]), .P(dummy1), .G(dummy2), .ovfl(ovfl[2]));
adder_4bit add2 (.A(A[7:4]), .B(B[7:4]), .C(1'b0), .Sum(tempSum[7:4]), .Cout(Cout[2]), .P(dummy1), .G(dummy2), .ovfl(ovfl[1]));
adder_4bit add3 (.A(A[3:0]), .B(B[3:0]), .C(1'b0), .Sum(tempSum[3:0]), .Cout(Cout[3]), .P(dummy1), .G(dummy2), .ovfl(ovfl[0]));

/*initial begin 
$monitor("ovfl: %b %b %b %b", ovfl[0], ovfl[1], ovfl[2], ovfl[3]);
end*/



assign  Sum[15:12] = (tempSum[15] & ovfl[3]) ? 4'b0111:
              (!tempSum[15] & ovfl[3] ) ? 4'b1000:tempSum[15:12];

assign  Sum[11:8] = (tempSum[11] & ovfl[2]) ? 4'b0111:
              (!tempSum[11] & ovfl[2]) ? 4'b1000:tempSum[11:8];

assign  Sum[7:4] = (tempSum[7] & ovfl[1]) ? 4'b0111:
              (!tempSum[7] & ovfl[1]) ? 4'b1000:tempSum[7:4];

assign  Sum[3:0] = (tempSum[3] & ovfl[0]) ? 4'b0111:
              (!tempSum[3] & ovfl[0]) ? 4'b1000:tempSum[3:0];


endmodule 
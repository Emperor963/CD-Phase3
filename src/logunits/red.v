module red (
    input [15:0] A,
    input [15:0] B,

    output [15:0] Sum
);

/*wire [3:0]A_a; //15-12
wire [3:0]A_b; //11-8
wire [3:0]A_c; //7-4
wire [3:0]A_d; //3-0

wire [3:0]B_a; //15-12
wire [3:0]B_b; //11-8
wire [3:0]B_c; //7-4
wire [3:0]B_d; //3-0 */

wire [3:0]Sum_a; //15-12
wire [3:0]Sum_b; //11-8
wire [3:0]Sum_c; //7-4
wire [3:0]Sum_d; //3-0

wire [15:0]Sum_f;

wire [3:0]to_addA;
wire [3:0]to_addB;

wire [3:0]Cout;

wire Cout2;
wire [5:0] dummy1, dummy2, dummy3;


adder_4bit add0 (.A(A[11:8]), .B(B[11:8]), .C(1'b0), .Sum(Sum_b), .Cout(Cout[0]), .P(dummy1[0]), .G(dummy2[0]), .ovfl(dummy3[0]));
adder_4bit add1 (.A(A[15:12]), .B(B[15:12]), .C(Cout[0]), .Sum(Sum_a), .Cout(Cout[1]), .P(dummy1[1]), .G(dummy2[1]), .ovfl(dummy3[1]));

adder_4bit add2 (.A(A[3:0]), .B(B[3:0]), .C(1'b0), .Sum(Sum_d), .Cout(Cout[2]), .P(dummy1[2]), .G(dummy2[2]), .ovfl(dummy3[2]));
adder_4bit add3 (.A(A[7:4]), .B(B[7:4]), .C(Cout[2]), .Sum(Sum_c), .Cout(Cout[3]), .P(dummy1[3]), .G(dummy2[3]), .ovfl(dummy3[3]));

adder_4bit add4 (.A(Sum_d), .B(Sum_b), .C(1'b0), .Sum(Sum_f[3:0]), .Cout(Cout2), .P(dummy1[4]), .G(dummy2[4]), .ovfl(dummy3[4]));
adder_4bit add5 (.A(Sum_c), .B(Sum_a), .C(Cout2), .Sum(Sum_f[7:4]), .Cout(Cout3), .P(dummy1[5]), .G(dummy2[5]), .ovfl(dummy3[5]));

assign to_addA = (Cout[1]) ? 4'b0001:4'b0000;
assign to_addB = (Cout[3]) ? 4'b0001:4'b0000;



adder_4bit add6 (.A(to_addA), .B(to_addB), .C(Cout2), .Sum(Sum_f[11:8]));

assign  Sum[15:9]  = (Sum_f[8]) ? 7'b1111111: 
                     (Sum_f[9]) ? 7'b0000001:7'b0000000;


assign Sum[8:0] = Sum_f[8:0];


endmodule 

module claAddSub(
    input[15:0] A,
    input[15:0] Bin,
    input Cin,
    input isSub,

    output [15:0] S,
    output Cout,
    output ovfl
); 

wire [15:0] B;
wire [3:0]dummy;
wire [3:0]dummy2;
wire [15:0]tempSum;

assign B =  Bin ^ {16{isSub}}; 



wire[3:0] LAcarry;
wire[3:0] gen;
wire[3:0] prop;
//wire[15:0] tempSum;

//assign Cin = isSub;
//assign S = {tempSum[15:1], tempSum[0]|isSub};

adder_4bit adder1(
    .A(A[3:0]),
    .B(B[3:0]),
    .C(isSub),
    .Sum(tempSum[3:0]),
    .Cout(dummy2[0]),
    .P(prop[0]),
    .G(gen[0]),
    .ovfl(dummy[0])
);

//THIS ADDER IS TO ADD THE ISSUB BIT TO NEGATION OF B IF ISSUB IS 1. IF THIS DOES
//NOT WORK, REVERT BACK TO Cin FOR adder_1 TO BEING isSub WITH NO CARRY IN.


adder_4bit adder2(
    .A(A[7:4]),
    .B(B[7:4]),
    .C(LAcarry[0]),
    .Sum(tempSum[7:4]),
    .Cout(dummy2[1]),
    .P(prop[1]),
    .G(gen[1]),
    .ovfl(dummy[1])
);


adder_4bit adder3(
    .A(A[11:8]),
    .B(B[11:8]),
    .C(LAcarry[1]),
    .Sum(tempSum[11:8]),
    .Cout(dummy[2]),
    .P(prop[2]),
    .G(gen[2]),
    .ovfl(dummy[2])
);


adder_4bit adder4(
    .A(A[15:12]),
    .B(B[15:12]),
    .C(LAcarry[2]),
    .Sum(tempSum[15:12]),
    .Cout(dummy2[3]),
    .P(prop[3]),
    .G(gen[3]),
    .ovfl(dummy[3])
);

CLA cla1 (.G(gen),.P(prop), .Cin(isSub), .Cout(LAcarry));

assign ovfl = (!A[15] & !B[15] & S[15]) | (A[15] & B[15] & !S[15]);

assign Cout = LAcarry[3];


assign  S[15:0] = (tempSum[15] & dummy[3]) ? 16'b0111_1111_1111_1111:
              (!tempSum[15] & dummy[3] ) ? 16'b1000_0000_0000_0000:tempSum[15:0];


endmodule
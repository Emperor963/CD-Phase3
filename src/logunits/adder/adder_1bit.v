
module adder_1bit (

    input A,
    input B,
    input  C,

    output Sum,
    output G,
    output P );
    

    assign G = (A & B);
    assign P = (A | B);

    assign Sum = A ^ B ^ C;  

endmodule 
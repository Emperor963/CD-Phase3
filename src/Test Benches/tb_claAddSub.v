`timescale 1ns/1ns

module tb_claAddSub;

    // Testbench signals
    reg signed [15:0] A;
    reg signed [15:0] Bin;
    reg Cin;
    reg isSub;

    wire signed [15:0] S;
    wire Cout;
    wire ovfl;

    // Instantiate the claAddSub module
    claAddSub uut (
        .A(A),
        .Bin(Bin),
        .Cin(Cin),
        .isSub(isSub),
        .S(S),
        .Cout(Cout),
        .ovfl(ovfl)
    );

    initial begin
        // Test Case 1: A = 10, B = 5 (Addition)
        A = 10;       // Decimal 10
        Bin = 5;      // Decimal 5
        isSub = 0;    // Addition
        Cin = 0;      // Carry in
        #10;          // Wait for 10 time units
        $display("A: %d, B: %d, isSub: %b, S: %d, Cout: %b, ovfl: %b", A, Bin, isSub, S, Cout, ovfl);

        // Test Case 2: A = 10, B = 5 (Subtraction)
        A = 10;       // Decimal 10
        Bin = 5;      // Decimal 5
        isSub = 1;    // Subtraction
        Cin = 0;      // Carry in
        #10;          // Wait for 10 time units
        $display("A: %d, B: %d, isSub: %b, S: %d, Cout: %b, ovfl: %b", A, Bin, isSub, S, Cout, ovfl);

        // Test Case 3: A = -10, B = 5 (Subtraction)
        A = -10;      // Decimal -10
        Bin = 5;      // Decimal 5
        isSub = 1;    // Subtraction
        Cin = 0;      // Carry in
        #10;          // Wait for 10 time units
        $display("A: %d, B: %d, isSub: %b, S: %d, Cout: %b, ovfl: %b", A, Bin, isSub, S, Cout, ovfl);

        // Test Case 4: A = -10, B = -5 (Addition)
        A = -10;      // Decimal -10
        Bin = -5;     // Decimal -5
        isSub = 0;    // Addition
        Cin = 0;      // Carry in
        #10;          // Wait for 10 time units
        $display("A: %d, B: %d, isSub: %b, S: %d, Cout: %b, ovfl: %b", A, Bin, isSub, S, Cout, ovfl);

        // Test Case 5: A = 10, B = -5 (Subtraction)
        A = 10;       // Decimal 10
        Bin = -5;     // Decimal -5
        isSub = 1;    // Subtraction
        Cin = 0;      // Carry in
        #10;          // Wait for 10 time units
        $display("A: %d, B: %d, isSub: %b, S: %d, Cout: %b, ovfl: %b", A, Bin, isSub, S, Cout, ovfl);

        // End the simulation
        $finish;
    end

endmodule

module tb_red;

    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] Sum;

    // Instantiate the red module
    red uut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );

    initial begin
        // Test Case 1
        A = 16'b0000_0000_0000_0001;
        B = 16'b0000_0000_0000_0001;
        #10;
        $display("Test Case 1 - A: %b, B: %b, Sum: %b", A, B, Sum);

        // Test Case 2
        A = 16'b0000_1111_0000_1111;
        B = 16'b0000_0000_1111_0000;
        #10;
        $display("Test Case 2 - A: %b, B: %b, Sum: %b", A, B, Sum);

        // Test Case 3
        A = 16'b1111_1111_1111_1111;
        B = 16'b0000_0000_0000_0001;
        #10;
        $display("Test Case 3 - A: %b, B: %b, Sum: %b", A, B, Sum);

        // Test Case 4
        A = 16'b0001_0010_0011_0100;
        B = 16'b0101_0110_0111_1000;
        #10;
        $display("Test Case 4 - A: %b, B: %b, Sum: %b", A, B, Sum);

        // Test Case 5
        A = 16'b1010_1011_1100_1101;
        B = 16'b1101_1100_1011_1010;
        #10;
        $display("Test Case 5 - A: %b, B: %b, Sum: %b", A, B, Sum);

        $finish;
    end

endmodule

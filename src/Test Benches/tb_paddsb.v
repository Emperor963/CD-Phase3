module tb_paddsb;

    // Declare testbench variables
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] Sum;

    // Instantiate the paddsb module
    paddsb uut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );

    // Test procedure
    initial begin
        // Test 1: Basic addition
        A = 16'b0001_0010_0011_0100;   // A = 0001 0010 0011 0100 (Hexadecimal)
        B = 16'b0100_0011_0010_0001;   // B = 0100 0011 0010 0001
        #10;            // Wait for 10 time units
        $display("Test 1: A = %h, B = %h, Sum = %h, Expected = 16'h5555", A, B, Sum);
        if (Sum !== 16'h5555) begin
            $display("Error: Test 1 failed! Expected 16'h5555, got %h", Sum);
        end

        // Test 2: Addition with overflow in lower nibble
        A = 16'hF234;   // A = 1111 0010 0011 0100 (Hexadecimal)
        B = 16'h1;      // B = 0000 0000 0000 0001
        #10;
        $display("Test 2: A = %h, B = %h, Sum = %h, Expected = 16'hF235", A, B, Sum);
        if (Sum !== 16'hF235) begin
            $display("Error: Test 2 failed! Expected 16'hF235, got %h", Sum);
        end

        // Test 3: Large values with overflow
        A = 16'hFFFF;   // A = 1111 1111 1111 1111 (Hexadecimal)
        B = 16'h0008;   // B = 0000 0000 0000 0001
        #10;
        $display("Test 3: A = %h, B = %h, Sum = %h, Expected = 16'h0000", A, B, Sum);
        if (Sum !== 16'hFFF8) begin
            $display("Error: Test 3 failed! Expected 16'hffff, got %h", Sum);
        end

        // Test 4: Zero addition
        A = 16'h0000;   // A = 0000 0000 0000 0000
        B = 16'h0000;   // B = 0000 0000 0000 0000
        #10;
        $display("Test 4: A = %h, B = %h, Sum = %h, Expected = 16'h0000", A, B, Sum);
        if (Sum !== 16'h0000) begin
            $display("Error: Test 4 failed! Expected 16'h0000, got %h", Sum);
        end

        // Test 5: Random inputs
        A = 16'hAAAA;   // A = 1010 1010 1010 1010
        B = 16'h5555;   // B = 0101 0101 0101 0101
        #10;
        $display("Test 5: A = %h, B = %h, Sum = %h, Expected = 16'hFFFF", A, B, Sum);
        if (Sum !== 16'hFFFF) begin
            $display("Error: Test 5 failed! Expected 16'hFFFF, got %h", Sum);
        end

        // Add more test cases as needed

        $finish;  // End simulation
    end

endmodule

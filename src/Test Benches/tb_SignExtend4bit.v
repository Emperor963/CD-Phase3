module tb_SignExtend4bit;

    // Testbench inputs
    reg [3:0] Ain;

    // Testbench outputs
    wire [15:0] Bout;

    // Instantiate the sign extend module
    SignExtend4bit uut (
        .A(Ain),
        .B(Bout)
    );

    // Test procedure
    initial begin
        // Monitor output for debugging
        $monitor("Time: %0d, in: %b, out: %b", $time, Ain, Bout);

        // Test with various inputs
        Ain = 4'b0111; #10; // Positive small number
        Ain = 4'b1000; #10; // Negative small number (two's complement)
        Ain = 4'b0010; #10; // Most negative 8-bit number (-128)
        Ain = 4'b0111; #10; // Largest positive 8-bit number (127)
        Ain = 4'b0000; #10; // Zero
        Ain = 4'b1111; #10; // -1 in two's complement

        // Finish simulation
        $finish;
    end

endmodule

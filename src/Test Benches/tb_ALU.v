`timescale 1ns / 1ps

module ALU_tb;

    // Declare testbench signals
    reg [15:0] In1;
    reg [15:0] In2;
    reg [2:0] ALUOp;
    reg [2:0] FLAG_in;
    
    reg [2:0] ALUOpE;


    
    wire [2:0] FLAG;
    wire [15:0] ALUOut;

    // Instantiate the ALU module
    ALU uut (
        .In1(In1),
        .In2(In2),
        .ALUOp(ALUOp),
        .FLAG_in(FLAG_in),
        .FLAG(FLAG),
        .ALUOut(ALUOut)
    );

    // Initial block to apply test cases
    initial begin
        // Test Case 1: ADD operation
        In1 = 16'h0010;       // Example value
        In2 = 16'h0004;       // Example value
        ALUOp = 3'b000;       // Assuming 3'b000 corresponds to ADD
        FLAG_in = 3'b000;
        #10;                  // Wait 10 ns

        // Display the result
        $display("ADD: In1=%b, In2=%b, ALUOp=%b, FLAG=%b, ALUOut=%b", In1, In2, ALUOp, FLAG, ALUOut);

        // Test Case 2: SUB operation
        In1 = 16'h0014;       // Example value
        In2 = 16'h0005;       // Example value
        ALUOp = 3'b001;       // Assuming 3'b001 corresponds to SUB
        FLAG_in = 3'b000;
        #10;

        $display("SUB: In1=%b, In2=%b, ALUOp=%b, FLAG=%b, ALUOut=%b", In1, In2, ALUOp, FLAG, ALUOut);

        // Test Case 3: XOR operation
        In1 = 16'hABCD;
        In2 = 16'hABCD;
        ALUOp = 3'b010;       // Assuming 3'b010 corresponds to AND
        FLAG_in = 3'b000;
        #10;

        $display("XOR: In1=%b, In2=%b, ALUOp=%b, FLAG=%b, ALUOut=%b", In1, In2, ALUOp, FLAG, ALUOut);

        // Test Case 4: RED operation
        In1 = 16'hFF00;
        In2 = 16'h00FF;
        ALUOp = 3'b011;       // Assuming 3'b011 corresponds to XOR
        FLAG_in = 3'b000;
        #10;

        $display("RED: In1=%b, In2=%b, ALUOp=%b, FLAG=%b, ALUOut=%b", In1, In2, ALUOp, FLAG, ALUOut);

        // Test Case 4: RED operation
        In1 = 16'b0001_0010_0011_0100;
        In2 = 16'b0000_0000_0000_0010;
        ALUOp = 3'b011;       // Assuming 3'b011 corresponds to XOR
        FLAG_in = 3'b000;
        #10;

        // Additional test cases can be added for other ALU operations

        // End simulation
        $finish;
    end

endmodule

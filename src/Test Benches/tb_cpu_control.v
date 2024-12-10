`timescale 1ns / 1ps

module cpu_control_tb;
    
    // Inputs
    reg [3:0] control;

    // Outputs
    wire RegRead;
    wire MemRead;
    wire [1:0] MemtoReg;
    wire MemWrite;
    wire [2:0] ALUOp;
    wire ALUsrc;
    wire RegWrite;
    wire [1:0] PCSour;
    wire LH;
    wire HLT;

    // Instantiate the cpu_control module
    cpu_control uut (
        .control(control), 
        .RegRead(RegRead), 
        .MemRead(MemRead), 
        .MemtoReg(MemtoReg), 
        .MemWrite(MemWrite), 
        .ALUOp(ALUOp), 
        .ALUsrc(ALUsrc), 
        .RegWrite(RegWrite), 
        .PCSour(PCSour), 
        .LH(LH), 
        .HLT(HLT)
    );

    // Task to check expected vs. actual and print result
    task check_output;
        input [3:0] ctrl;
        input [6:0] exp_result;
        input [2:0] exp_ALU;
        input [1:0] exp_MR;
        input [1:0] exp_PCSource;
        input exp_HLT;
        
        begin
            if ({RegRead, MemRead, MemWrite, ALUsrc, RegWrite, LH, HLT} === exp_result && 
                ALUOp === exp_ALU && 
                MemtoReg === exp_MR && 
                PCSour === exp_PCSource &&
                HLT === exp_HLT) begin
                $display("Control = %b: PASS", ctrl);
            end else begin
            $display("Control = %b: FAIL", ctrl);
            $display("Actual Values:");
            $display("    RegRead: %b", RegRead);
            $display("    MemRead: %b", MemRead);
            $display("    MemWrite: %b", MemWrite);
            $display("    ALUsrc: %b", ALUsrc);
            $display("    RegWrite: %b", RegWrite);
            $display("    LH: %b", LH);
            $display("    HLT: %b", HLT);
            $display("    MemtoReg: %b", MemtoReg);
            $display("    ALUOp: %b", ALUOp);
            $display("    PCSour: %b", PCSour);

            end
        end
    endtask

    // Test cases
    initial begin
        $display("Starting test...");

        // ADD
        control = 4'b0000; #10;
        check_output(control, 7'b10001x0, 3'b000, 2'b10, 2'b00, 1'b0);

        // SUB
        control = 4'b0001; #10;
        check_output(control, 7'b10001x0, 3'b001, 2'b10, 2'b00, 1'b0);

        // XOR
        control = 4'b0010; #10;
        check_output(control, 7'b10001x0, 3'b010, 2'b10, 2'b00, 1'b0);

        // RED
        control = 4'b0011; #10;
        check_output(control, 7'b10001x0, 3'b011, 2'b10, 2'b00, 1'b0);

        // SLL
        control = 4'b0100; #10;
        check_output(control, 7'b10011x0, 3'b100, 2'b10, 2'b00, 1'b0);

        // SRA
        control = 4'b0101; #10;
        check_output(control, 7'b10011x0, 3'b101, 2'b10, 2'b00, 1'b0);

        // ROR
        control = 4'b0110; #10;
        check_output(control, 7'b10011x0, 3'b110, 2'b10, 2'b00, 1'b0);

        // PADDSB
        control = 4'b0111; #10;
        check_output(control, 7'b10001x0, 3'b111, 2'b10, 2'b00, 1'b0);

        // LW
        control = 4'b1000; #10;
        check_output(control, 7'b11011x0, 3'b000, 2'b11, 2'b00, 1'b0);

        // SW
        control = 4'b1001; #10;
        check_output(control, 7'b1011000, 3'b000, 2'b00, 2'b00, 1'b0);

        // LLB
        control = 4'b1010; #10;
        check_output(control, 7'b0000100, 3'b000, 2'b01, 2'b00, 1'b0);

        // LHB
        control = 4'b1011; #10;
        check_output(control, 7'b0000110, 3'b000, 2'b01, 2'b00, 1'b0);

        // B
        control = 4'b1100; #10;
        check_output(control, 7'b0000000, 3'b000, 2'b00, 2'b11, 1'b0);

        // BR
        control = 4'b1101; #10;
        check_output(control, 7'b1000000, 3'b000, 2'b00, 2'b01, 1'b0);

        // PCS
        control = 4'b1110; #10;
        check_output(control, 7'b0000100, 3'b000, 2'b00, 2'b00, 1'b0);

        // HLT
        control = 4'b1111; #10;
        check_output(control, 7'b0000001, 3'b000, 2'b00, 2'b01, 1'b1);

        $display("Test complete.");
        $stop;
    end

endmodule

module check(
    input [15:0] ex,
    input [15:0] out
);

always @(*) begin
    if (out == ex) begin
        $display("Test Passed: output: %b expected: %b", out, ex);
    end else begin
        $display("Test Failed: output: %b expected: %b", out, ex);
    end
end

endmodule

module tb_Mux;

reg [15:0] A;
reg [15:0] B;
reg Cin;

wire outtb;

MUX16bit_2to1 Mux1 ( .sigA(A), .sigB(B), .control (Cin), .out(outtb));

initial begin

    A = 16'b1111_1111_1111_1111;
    B = 16'b0000_0000_0000_0000;

    Cin = 1;
    check test1 (.ex(B), .out(outtb));
    Cin = 0;
    check test2 (.ex(A), .out(outtb));

    end
endmodule



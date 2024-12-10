module tb_pc_control;
    reg [15:0] pc_in;
    reg [8:0] imm;
    reg [2:0] FLAG;
    reg [2:0] C;

    wire [15:0] pc_out;

    pc_control uut(.pc_in(pc_in), .imm(imm), .FLAG(FLAG), .C(C));


    initial begin

        pc_in = 16'h0000;


        //test 1: 
        imm = 9'b0_0000_0001;
        FLAG = 3'b000;
        C = 3'b000;
        #10
        if (pc_out != 16'b0000_0000_0000_0011) begin
            $display("Error: Test 1 failed! Expected 16'h0003, got %h", pc_out);
        end else begin 
            $display("test 1 passed!");
        end    

        //test 2: 
        imm = 9'b0_0000_0001;
        FLAG = 3'b001;
        C = 3'b000;
        #10
        if (pc_out != 16'b0000_0000_0000_0000) begin
            $display("Error: Test 2 failed! Expected 16'h0000, got %h", pc_out);
        end else begin 
            $display("test 2 passed!");
        end  

        //test 3: 
        imm = 9'b0_0000_0010;
        FLAG = 3'b001;
        C = 3'b001;
        #10
        if (pc_out != 16'b0000_0000_0000_0110) begin
            $display("Error: Test 3 failed! Expected 16'h0000, got %h", pc_out);
        end else begin 
            $display("test 3 passed!");
        end  

        //test 3: 
        imm = 9'b0_0000_0010;
        FLAG = 3'b010;
        C = 3'b010;
        #10
        if (pc_out != 16'b0000_0000_0000_0110) begin
            $display("Error: Test 3 failed! Check Greater Than Case: Expected 16'h0000, got %h", pc_out);
        end else begin 
            $display("test 4 passed!");
        end  
        

        //test 3: 
        imm = 9'b0_0000_0010;
        FLAG = 3'b011;
        C = 3'b011;
        #10
        if (pc_out != 16'b0000_0000_0000_0110) begin
            $display("Error: Test 3 failed! Check Less Than Case: Expected 16'h0000, got %h", pc_out);
        end else begin 
            $display("test 2 passed!");
        end  




    end



endmodule
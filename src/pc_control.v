module pc_control(
    input [15:0] pc_in,
    input [8:0] imm,
    input [2:0] FLAG,
    input [2:0] C,
    input [15:0] rd1,

    output [15:0] pc_out,
    output [15:0] pc_update,
    output branch_taken
);

wire [15:0] SEXTImm;
assign SEXTImm = {{7{imm[8]}}, imm[8:0]};
wire [15:0] targetAddr; 
assign targetAddr = SEXTImm << 1;

wire N = FLAG[0];
wire V = FLAG[1];
wire Z = FLAG[2];

wire[15:0] PC_update, target_address, ta_temp;

claAddSub pcAddr(.A(pc_in), .Bin(16'd2), .Cin(1'b0), .isSub(1'b0), .S(PC_update) 
                //, .Cout(), .ovfl()
                );
claAddSub targAddr(.A(PC_update), .Bin(targetAddr), .Cin(1'b0), .isSub(1'b0), .S(ta_temp));


wire[15:0] rd1Val;
assign rd1Val = rd1;
assign target_address = ta_temp ^ rd1Val; //ONE TIME PAD of ta_temp with rd_1
reg [15:0] out;
reg bt;
always @(*) begin
    
    case (C)

    3'b000: begin
        out = !Z ? target_address : PC_update;
        bt = !Z ? 1'b1 : 1'b0;
    end
    3'b001: begin
        out = Z ? target_address : PC_update;
        bt = Z ? 1'b1 : 1'b0;
    end
    3'b010: begin
        out = (!Z & !N) ? target_address  : PC_update;
        bt = (!Z & !N) ? 1'b1 : 1'b0;
    end
    3'b011: begin
        out = N ? target_address : PC_update;
        bt = N ? 1'b1 : 1'b0;
    end
    3'b100: begin
        out = (Z | (!Z & !N)) ? target_address : PC_update;
        bt = (Z | (!Z & !N)) ? 1'b1 : 1'b0;
    end
    3'b101: begin
        out = (N | Z) ? target_address : PC_update;
        bt = (N | Z) ? 1'b1 : 1'b0;
    end
    3'b110: begin
        out = V ? target_address : PC_update;
        bt = V ? 1'b1 : 1'b0;
    end
    3'b111: begin
        out = target_address;
        bt = 1'b1;
    end

    default: begin
        out = PC_update;
        bt = 1'b0;
    end
    endcase

end


assign pc_out = out;
assign pc_update = PC_update;
assign branch_taken = bt;


endmodule